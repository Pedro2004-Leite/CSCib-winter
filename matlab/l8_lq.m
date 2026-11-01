%% L8 - Projeto LQ no modelo identificado (Seccao 5.1)


% Para que nada seja contaminado 
clear; close all
% Carrega o modelo 
F = load('../models/final.mat');
A = F.A; B = F.B; C = F.C; D = F.D; Ts = F.Ts;
n = size(A, 1); %Dimensao do estado  

%% 1. Ganho LQ com R = 100
% Ganhos do LQ
Q = C'*C;
R = 100;

%Resolve a equaçao algebrica de Ricatti em tempo discreto e devolve S ;
%Devolve o ganho K da realimentacao, S e E que sao os valores proprios da
%cadeia fechada. 

[K, S, E] = dlqr(A, B, Q, R);

fprintf('K = %s\n', mat2str(K, 5))
fprintf('|polos| de A-BK: %s\n', mat2str(abs(E)', 4))

%% 2. Root-square locus em R
% Os polos de A-BK sao as raizes estaveis do locus; varre-se R de 1e-4 a 1e6
% Para fazer o rootlocus; Em vez de resolver as raizes estaveis de uma eq
% simetrica, faz-se por força bruta. 

Rs = logspace(-4, 6, 400); 

polos = zeros(numel(Rs), n); %numel conta o numero de elementos

for i = 1:numel(Rs)
    polos(i, :) = eig(A - B*dlqr(A, B, Q, Rs(i)));
end
E100 = eig(A - B*K);

fig = ieee_figura('pagina', 3.6);
theta = linspace(0, 2*pi, 400);
plot(cos(theta), sin(theta), 'Color', [0.7 0.7 0.7], 'LineWidth', 0.5, ...
    'DisplayName', 'círculo unitário'), hold on
plot(real(polos(:)), imag(polos(:)), '.', 'Color', [0 0.447 0.741], ...
    'MarkerSize', 4, 'DisplayName', 'polos de A−BK, R de 10⁻⁴ a 10⁶')
plot(real(eig(A)), imag(eig(A)), 'kx', 'MarkerSize', 9, 'LineWidth', 1.5, ...
    'DisplayName', 'polos de A (R → ∞)')
plot(real(E100), imag(E100), 'o', 'Color', [0.85 0.325 0.098], ...
    'MarkerSize', 8, 'LineWidth', 1.5, 'DisplayName', 'polos com R = 100')
axis equal, grid on
xlabel('Parte real'), ylabel('Parte imaginária')
legend('Location', 'southwest')
ieee_guarda(fig, 'l8_rsl')


%Analise da figura: 
% 1. Quando R -> inf, os polos vao para os polos de A
% 2. Quando R -> 0, os polos vao para os zeros de G(z) dentro do circulo.
% Cada zero fora do circulo, basicamente passa a existir o seu inverso. 
% Os polos restantes vao para a origem; Isto e a indicaçao que o processo
% fica mais rapido. 

%% 3. Simulacao da realimentacao de estado

%1. Calcula-se Nx e Nu
Nm = inv([A - eye(n), B; C, 0]) * [zeros(n, 1); 1];
%Retira-se Nx e Nu; 
Nx = Nm(1:n); Nu = Nm(n+1);
%2. Calcula-se o pre-filtro para a lei de controlo sobre a referencia
Nbar = Nu + K*Nx;

Rtest = [1 10 100 1000];
t = (0:Ts:3)A;
fig = ieee_figura('pagina', 4.8);
ax1 = subplot(2, 1, 1); hold on
ax2 = subplot(2, 1, 2); hold on
resumo = zeros(numel(Rtest), 4);
    o
for j = 1:numel(Rtest)
    Kj = dlqr(A, B, Q, Rtest(j)); %calcula-se ganho do LQR 
    Nbj = Nu + Kj*Nx;
    Acl = A - B*Kj;
    sys = ss(Acl, B*Nbj, C, 0, Ts);
    [y, ~, x] = lsim(sys, ones(size(t)), t); %Simula-se o sistema 
    %Linear, com entrada (ref) igual a 1, 
    u = -x*Kj' + Nbj; % Calcula-se a lei de controlo 
    plot(ax1, t, y, 'LineWidth', 1.5, 'DisplayName', sprintf('R = %g', Rtest(j)))
    plot(ax2, t, u, 'LineWidth', 1.5, 'DisplayName', sprintf('R = %g', Rtest(j)))
    si = stepinfo(y, t, 1, 'SettlingTimeThreshold', 0.02);
    resumo(j, :) = [Rtest(j), si.SettlingTime, si.Overshoot, max(abs(u))];
end
grid(ax1, 'on'), grid(ax2, 'on')
ylabel(ax1, 'y [°]'), ylabel(ax2, 'u [V]'), xlabel(ax2, 'Tempo [s]')
legend(ax1, 'Location', 'southeast')
ieee_guarda(fig, 'l8_step')

%% Resultados
fid = fopen('../results/l8_lq.txt', 'w');
fprintf(fid, 'L8 - LQ com Q = C''C (modelo %s, Ts = %g s)\n', 'final', Ts);
fprintf(fid, 'R = %g\nK = %s\nNbar = %.4g\n', R, mat2str(K, 5), Nbar);
fprintf(fid, 'Polos de A-BK: %s\n', mat2str(E', 4));
fprintf(fid, '\n  R   assent.(2%%) [s]   sobreelevacao [%%]   max|u| [V]\n');
fprintf(fid, '%6g   %8.3f   %8.2f   %8.3f\n', resumo');
fclose(fid);
type ../results/l8_lq.txt

save('../models/lq.mat', 'K', 'Nbar', 'Nx', 'Nu', 'Q', 'R')
