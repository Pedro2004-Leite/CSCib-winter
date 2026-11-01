%% L9 - Filtro de Kalman, LTR e simulacao LQG (Seccoes 5.2 a 5.4)
% Calcula o ganho M com dlqe (Qw = 100 I, Rv = 1), estuda os polos do
% observador em funcao de Rv (root-square locus), e simula o LQG completo
% (observador corrente + K + pre-filtro Nbar) no modelo identificado.
% Requer l8_lq.m ja corrido (models/lq.mat).

clear; close all
F = load('../models/final.mat');
A = F.A; B = F.B; C = F.C; D = F.D; Ts = F.Ts;
L = load('../models/lq.mat');
K = L.K; Nbar = L.Nbar;
n = size(A, 1);

%% 1. Ganho de Kalman
Qw = 100*eye(n);
Rv = 1;
[M, P, Z, Eobs] = dlqe(A, eye(n), C, Qw, Rv);   % M: ganho do observador corrente
fprintf('M = %s\n', mat2str(M', 5))
fprintf('Polos do observador: %s\n', mat2str(Eobs', 4))

%% 2. Root-square locus do observador em Rv
Rvs = logspace(-4, 6, 400);
polos = zeros(numel(Rvs), n);
for i = 1:numel(Rvs)
    [~, ~, ~, Ei] = dlqe(A, eye(n), C, Qw, Rvs(i));
    polos(i, :) = sort(Ei);
end
fig = ieee_figura('pagina', 3.6);
theta = linspace(0, 2*pi, 400);
plot(cos(theta), sin(theta), 'Color', [0.7 0.7 0.7], 'LineWidth', 0.5, ...
    'DisplayName', 'círculo unitário'), hold on
plot(real(polos(:)), imag(polos(:)), '.', 'Color', [0 0.447 0.741], ...
    'MarkerSize', 4, 'DisplayName', 'polos do observador, Rv de 10⁻⁴ a 10⁶')
plot(real(eig(A)), imag(eig(A)), 'kx', 'MarkerSize', 9, 'LineWidth', 1.5, ...
    'DisplayName', 'polos de A (Rv → ∞)')
plot(real(Eobs), imag(Eobs), 'o', 'Color', [0.85 0.325 0.098], ...
    'MarkerSize', 8, 'LineWidth', 1.5, 'DisplayName', 'polos com Rv = 1')
axis equal, grid on
xlabel('Parte real'), ylabel('Parte imaginária')
legend('Location', 'southwest')
ieee_guarda(fig, 'l9_rsl')

%% 3. Simulacao LQG em malha fechada
% Planta: x+ = Ax + Bu + w, y = Cx + v. Controlador (observador corrente):
%   xp = A xh + B u(k-1);  xh = xp + M (y - C xp);  u = -K xh + Nbar r
Nt = 150; t = (0:Nt-1)'*Ts;
r = ones(Nt, 1); 
rng(1)
Rvs_sim = [0.01 1 100];     % Rv usado no projeto do observador
sigv = 0.1;                 % ruido de medida real [graus]
sigw = 0.02;               % ruido de processo real
fig = ieee_figura('pagina', 4.8);
ax1 = subplot(2, 1, 1); hold on
ax2 = subplot(2, 1, 2); hold on
v = sigv*randn(Nt, 1); w = sigw*randn(n, Nt);   % mesmo ruido para todos
res = zeros(numel(Rvs_sim), 3);
for j = 1:numel(Rvs_sim)
    Mj = dlqe(A, eye(n), C, Qw, Rvs_sim(j));
    x = zeros(n, 1); xh = zeros(n, 1); uk = 0;
    y = zeros(Nt, 1); u = zeros(Nt, 1); yt = zeros(Nt, 1);
    for k = 1:Nt
        yt(k) = C*x;                 % saida verdadeira
        y(k) = yt(k) + v(k);
        xp = A*xh + B*uk;
        xh = xp + Mj*(y(k) - C*xp);
        uk = -K*xh + Nbar*r(k);
        u(k) = uk;
        x = A*x + B*uk + w(:, k);
    end
    plot(ax1, t, yt, 'LineWidth', 1.5, 'DisplayName', sprintf('Rv = %g', Rvs_sim(j)))
    plot(ax2, t, u, 'LineWidth', 1.5, 'DisplayName', sprintf('Rv = %g', Rvs_sim(j)))
    res(j, :) = [Rvs_sim(j), std(yt(end-50:end) - 1), std(u(end-50:end))];
end
plot(ax1, t, r, 'k', 'LineWidth', 0.5, 'DisplayName', 'referência')
grid(ax1, 'on'), grid(ax2, 'on')
ylabel(ax1, 'y [°]'), ylabel(ax2, 'u [V]'), xlabel(ax2, 'Tempo [s]')
legend(ax1, 'Location', 'southeast')
ieee_guarda(fig, 'l9_lqg')

%% 4. Resposta em frequencia e ganho de malha do LQG (Seccao 5.5)
% Controlador y -> u do observador corrente, com o estado de predicao xp:
%   xp+ = (A-BK)(I-MC) xp + (A-BK) M y,   u = -K(I-MC) xp - K M y
I = eye(n);
Gc = ss((A-B*K)*(I-M*C), (A-B*K)*M, -K*(I-M*C), -K*M, Ts);
Gp = ss(A, B, C, D, Ts);
Lg = -Gp*Gc;                             % ganho de malha aberta em u (realim. negativa)
fig = ieee_figura('pagina', 3.8);
[mag, fas, w] = bode(Lg);
ax1 = subplot(2, 1, 1);
semilogx(w, 20*log10(squeeze(mag)), 'LineWidth', 1.5), grid on
ylabel('Ganho [dB]')
ax2 = subplot(2, 1, 2);
semilogx(w, squeeze(fas), 'LineWidth', 1.5), grid on
ylabel('Fase [°]'), xlabel('Frequência [rad/s]')
ieee_guarda(fig, 'l9_loopgain')

%% Resultados
Tcl = feedback(Lg, 1);
fid = fopen('../results/l9_lqg.txt', 'w');
fprintf(fid, 'L9 - LQG (Qw = 100 I, Rv = 1)\n');
fprintf(fid, 'M'' = %s\nPolos do observador: %s\n', mat2str(M', 5), mat2str(Eobs', 4));
fprintf(fid, 'Polos de A-BK: %s\n', mat2str(eig(A - B*K)', 4));
fprintf(fid, 'Polos de malha fechada (LQG): %s\n', mat2str(sort(pole(Tcl))', 4));
[Gm, Pm] = margin(Lg);
fprintf(fid, 'Margem de ganho: %.2f dB, de fase: %.1f graus\n', 20*log10(Gm), Pm);
fprintf(fid, '\n  Rv   std(y-r) real final [graus]   std(u) final [V]\n');
fprintf(fid, '%6g   %8.4f   %8.4f\n', res');
fclose(fid);
type ../results/l9_lqg.txt
