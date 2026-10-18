%% Figuras da Q3 do relatorio (Parte I, identificacao)
% Gera as figuras no estilo IEEE (ver ieee_figura.m e ieee_guarda.m) e
% guarda-as em ../report/Figs como PDF vetorial e PNG de 600 dpi.
% Corre revisao.m e identificacao.m antes: a figura do varrimento le
% results/revisao.mat e results/<modelo>_grelha.mat.
% Convencao de sinais (a mesma da identificacao): Kp < 0 e Ke > 0.
% Cada figura deve perceber-se sozinha: os elementos importantes tem rotulo
% ao lado e a legenda no documento define o que resta.

Kp = -32.99;            % potenciometro [graus/V]
Ke = 3.9675;            % extensometro [graus/V]
t0 = 5;                 % segundos iniciais descartados na validacao
modelo = 'exp2_quad_1V';

% Cores distinguiveis por daltonicos (Okabe-Ito). Todas as linhas sao
% continuas: as curvas distinguem-se por cor, brilho, marcador e rotulo
% junto da curva, nunca so pela cor
cAzul = [0 0.45 0.70];
cVerm = [0.84 0.37 0];
cCinza = [0.4 0.4 0.4];
cBanda = [0.92 0.92 0.92];
LW = 1.25;              % espessura das curvas de dados [pt]

%% Fig. 1 - Convencao de sinais (motor desligado, barra empurrada a mao)
% As faixas cinzentas marcam os movimentos; cada uma diz se theta_e desce
% ou sobe e qual o sinal de alpha_e durante o movimento.
S = load('../data/exp_signconvention.mat');
t = S.dados.time;
v = S.dados.signals.values;

k = 10;                                         % variacao ao longo de 0.2 s
dp = [zeros(k,1); v(k+1:end,2) - v(1:end-k,2)];
d = diff([0; abs(dp) > 0.05; 0]);
ini = find(d == 1); fim = find(d == -1) - 1;
i = 1;                                          % juntar intervalos a menos de 0.5 s
while i < numel(ini)
    if ini(i+1) - fim(i) < 25
        fim(i) = fim(i+1); ini(i+1) = []; fim(i+1) = [];
    else
        i = i + 1;
    end
end

fig = ieee_figura('pagina', 2.8);
tl = tiledlayout(2, 1, 'TileSpacing', 'compact', 'Padding', 'compact');
ax1 = nexttile(tl); hold on
ax2 = nexttile(tl); hold on
yl1 = [-1.6 2.1]; yl2 = [-1.7 1.8];
for j = 1:numel(ini)
    x = [t(ini(j)) t(fim(j)) t(fim(j)) t(ini(j))];
    patch(ax1, x, yl1([1 1 2 2]), cBanda, 'EdgeColor', 'none', 'HandleVisibility', 'off')
    patch(ax2, x, yl2([1 1 2 2]), cBanda, 'EdgeColor', 'none', 'HandleVisibility', 'off')
    xc = mean(x(1:2));
    if v(fim(j), 2) < v(ini(j), 2)              % theta_e desce
        text(ax1, xc, -1.38, 'falling', 'HorizontalAlignment', 'center')
        text(ax2, xc, 1.45, 'αₑ>0', 'HorizontalAlignment', 'center')
    else                                        % theta_e sobe
        text(ax1, xc, -1.38, 'rising', 'HorizontalAlignment', 'center')
        text(ax2, xc, 1.45, 'αₑ<0', 'HorizontalAlignment', 'center')
    end
end
plot(ax1, t, v(:,2), 'Color', cAzul, 'LineWidth', LW)
plot(ax2, t, v(:,3), 'Color', cVerm, 'LineWidth', LW)
ylabel(ax1, 'θₑ (V)'), ylim(ax1, yl1), grid(ax1, 'on')
ylabel(ax2, 'αₑ (V)'), ylim(ax2, yl2), grid(ax2, 'on')
xlabel(ax2, 'Time (s)')
set(ax1, 'XTickLabel', [])
text(ax1, 0.01, 0.9, '(a)', 'Units', 'normalized')
text(ax2, 0.01, 0.1, '(b)', 'Units', 'normalized')
set([ax1 ax2], 'XLim', [0 40])
ieee_guarda(fig, 'q3_signconv')

%% Fig. 2 - Amplitude da excitacao: zona morta
amps = [0.15 0.2 0.3 1 1.5];
cores = {cCinza, cCinza, [0 0 0], cAzul, cVerm};
vel = zeros(size(amps));

fig = ieee_figura('pagina', 2.5);
tl = tiledlayout(1, 2, 'TileSpacing', 'compact', 'Padding', 'compact');
nexttile(tl), hold on
for k = 1:numel(amps)
    S = load(sprintf('../data/exp2_quad_%gV.mat', amps(k)));
    t = S.dados.time;
    v = S.dados.signals.values;
    ang = (v(:,2) - v(1,2))*Kp;                 % variacao do angulo do eixo [graus]
    m = t <= 5;
    plot(t(m), ang(m), '-', 'Color', cores{k}, 'LineWidth', LW)
    j = find(t >= 0.5 & t <= 1.1);              % parte a velocidade constante
    p = polyfit(t(j), v(j,2), 1);
    vel(k) = p(1)*Kp;                           % velocidade do eixo [graus/s]
end
% Rotulos junto das curvas, na cor de cada uma (a ordem vertical e a das curvas)
text(2.7, 165, '±1.5 V', 'Color', cVerm)
text(2.7, 140, '±1 V', 'Color', cAzul)
text(0.1, -17, '±0.15, ±0.2, ±0.3 V')
xlabel('Time (s)'), ylabel('Shaft angle change (deg)'), grid on
xlim([0 5]), ylim([-30 175])
text(0.02, 0.92, '(a)', 'Units', 'normalized')

nexttile(tl), hold on
pf = polyfit(amps(3:end), vel(3:end), 1);       % reta pelos pontos fora da zona morta
a0 = -pf(2)/pf(1);                              % amplitude onde a velocidade se anula
xx = [0 1.6];
hp = plot(amps, vel, 'o', 'Color', cAzul, 'MarkerFaceColor', cAzul, 'MarkerSize', 5);
hr = plot(xx, polyval(pf, xx), '-', 'Color', cCinza, 'LineWidth', 0.75);
hz = plot(a0, 0, 's', 'Color', cVerm, 'MarkerFaceColor', 'w', 'MarkerSize', 6, 'LineWidth', LW);
yline(0, 'Color', 'k', 'LineWidth', 0.5, 'HandleVisibility', 'off');
legend([hp hr hz], {'Measured', 'Linear fit', 'Dead zone'}, 'Location', 'southeast')
xlabel('Square-wave amplitude (V)'), ylabel('Shaft speed (deg/s)'), grid on
xlim([0 1.6]), ylim([-30 140])
text(0.02, 0.92, '(b)', 'Units', 'normalized')
ieee_guarda(fig, 'q3_amplitude')
fprintf('Zona morta: %.2f V; ganho fora da zona morta: %.0f graus/s por V\n', a0, pf(1))

%% Fig. 3 - Revisao da identificacao: ajuste nos dados de validacao
R = load('../results/revisao.mat');
af  = cell2mat(R.variacoes(:,2));
na  = cell2mat(R.variacoes(:,3));
nb  = cell2mat(R.variacoes(:,4));
dec = cell2mat(R.variacoes(:,5));
aj  = R.ajustes;
base = abs(af - 0.8) < 1e-9 & na == 4 & nb == 3 & dec == 1;

fig = ieee_figura('pagina', 2.8);
tl = tiledlayout(1, 3, 'TileSpacing', 'compact', 'Padding', 'compact');

idx = find(na == 4 & nb == 3 & dec == 1);       % varia so o polo do filtro
[~, o] = sort(af(idx)); idx = idx(o);
ax1 = nexttile(tl);
curva_revisao(af(idx), aj(idx), base(idx), cAzul, cVerm, LW);
xlabel('Filter pole'), ylabel('Validation fit (%)')
text(0.04, 0.92, '(a)', 'Units', 'normalized')

G = load(['../results/' modelo '_grelha.mat']);   % ajuste para na = 2..6 e nb = 1..4
ax2 = nexttile(tl); hold on
marcas = {'o', 's', '^', 'd'};
cores_nb = {[0.65 0.65 0.65], [0.35 0.35 0.35], cAzul, [0 0 0]};
for j = 1:4
    plot(2:6, G.grelha(:, j), '-', 'Marker', marcas{j}, 'Color', cores_nb{j}, ...
        'LineWidth', LW, 'MarkerSize', 4, 'MarkerFaceColor', 'w', ...
        'DisplayName', sprintf('nb = %d', j))
end
plot(4, G.grelha(3, 3), 's', 'Color', cVerm, 'MarkerFaceColor', cVerm, ...
    'MarkerSize', 6, 'DisplayName', 'adopted')
lgd = legend('NumColumns', 5);              % legenda unica, por baixo dos tres paineis
lgd.Layout.Tile = 'south';
grid on
xlabel('Denominator order, nₐ'), set(ax2, 'XTick', 2:6, 'YTickLabel', [])
text(0.04, 0.92, '(b)', 'Units', 'normalized')

idx = find(abs(af - 0.8) < 1e-9 & na == 4 & nb == 3);    % varia so o periodo
[~, o] = sort(dec(idx)); idx = idx(o);
ax3 = nexttile(tl);
curva_revisao(0.02*dec(idx), aj(idx), base(idx), cAzul, cVerm, LW);
xlabel('Sampling period, Tₛ (s)'), set(ax3, 'YTickLabel', [])
text(0.04, 0.92, '(c)', 'Units', 'normalized')
set([ax1 ax2 ax3], 'YLim', [64 92])
set(ax1, 'XLim', [0.45 1], 'XTick', [0.5 0.75 1]), set(ax2, 'XLim', [1.7 6.3]), set(ax3, 'XLim', [0 0.11])
ieee_guarda(fig, 'q3_review')

%% Fig. 4 - Modelo final: polos e zeros (q3_pz) e resposta em frequencia (q3_bode)
M = load(['../models/ss_' modelo '.mat']);
Mi = load(['../models/' modelo '.mat']);   % ARMAX da saida derivada e filtrada (num1, den1)
num = M.num; den = M.den; Ts = M.Ts;
polos = roots(den);
zeros_ = roots(num);
w = logspace(-1, log10(pi/Ts) - 0.01, 600);     % ate perto da frequencia de Nyquist
z = exp(1j*w*Ts);
H = polyval(num, z)./polyval(den, z);
pb = polos(imag(polos) > 1e-6);                 % par complexo: modo da barra
wn = abs(log(pb(1))/Ts);                        % frequencia natural [rad/s]
reais = real(polos(abs(imag(polos)) < 1e-6));   % polos reais
pm = reais(reais > 0 & abs(reais - 1) > 1e-3);  % motor
pe = reais(reais < 0);                          % polo extra
zf = real(zeros_(abs(zeros_) > 1));             % zero fora do circulo unitario

% (a) Polos e zeros; cada tipo de polo tem um marcador proprio, explicado na legenda
fig = ieee_figura('pagina', 2.6);
ax = axes(fig, 'Position', [0.115 0.2 0.52 0.75]); hold(ax, 'on')
th = linspace(0, 2*pi, 200);
plot(cos(th), sin(th), '-', 'Color', cCinza, 'LineWidth', 0.5, 'HandleVisibility', 'off')
h1 = plot(1, 0, 'x', 'Color', cAzul, 'MarkerSize', 7, 'LineWidth', LW);
h2 = plot([pm; pe], [0; 0], '+', 'Color', cAzul, 'MarkerSize', 8, 'LineWidth', LW);   % motor e filtro
h3 = plot(real(pb), imag(pb), 'd', 'Color', cAzul, 'MarkerSize', 6, 'LineWidth', LW);
zn = zeros_(abs(zeros_) < 1.5);                 % zeros dentro e perto do circulo
h5 = plot(real(zn), imag(zn), 'o', 'Color', cVerm, 'MarkerSize', 6, 'LineWidth', LW);
h6 = plot(zf, 0, 'o', 'Color', cVerm, 'MarkerFaceColor', cVerm, 'MarkerSize', 6, 'LineWidth', LW);
axis equal, xlim([-1.3 3.0]), ylim([-1.2 1.2]), grid on
xlabel('Real part'), ylabel('Imaginary part')
lgd = legend([h1 h2 h3 h5 h6], {'Integrator', 'Motor + filter', 'Bar mode', ...
    'Zero', 'Non-min. phase zero'}, 'Location', 'none');
lgd.Position = [0.69 0.3 0.3 0.45];
text(0.02, 0.1, '(a)', 'Units', 'normalized')
ieee_guarda(fig, 'q3_pz')

% (b), (c) Resposta em frequencia: modulo e fase lado a lado
fig = ieee_figura('pagina', 2.3);
tl = tiledlayout(1, 2, 'TileSpacing', 'compact', 'Padding', 'compact');
ax2 = nexttile(tl);
semilogx(w, 20*log10(abs(H)), 'Color', cAzul, 'LineWidth', LW), hold on
xline(wn, '-', 'Color', cCinza, 'LineWidth', 0.5);
xlabel('Frequency (rad/s)'), ylabel('Magnitude (dB)'), grid on
text(0.02, 0.1, '(b)', 'Units', 'normalized')
ax3 = nexttile(tl);
semilogx(w, unwrap(angle(H))*180/pi, 'Color', cAzul, 'LineWidth', LW), hold on
xline(wn, '-', 'Color', cCinza, 'LineWidth', 0.5);
xlabel('Frequency (rad/s)'), ylabel('Phase (deg)'), grid on
text(0.02, 0.1, '(c)', 'Units', 'normalized')
set([ax2 ax3], 'XLim', [0.1 pi/Ts], 'XTick', [0.1 1 10 100])
ieee_guarda(fig, 'q3_bode')

%% Fig. 5 - Validacao: angulo da ponta, dados contra modelo
V = load('../data/exp2_val_1V.mat');
sv = V.dados.signals.values;
uv = sv(:,1);
yv = sv(:,2)*Kp + sv(:,3)*Ke;
n0 = round(t0/Ts) + 1;
y_sim = filter(num, den, uv(n0:end));
y_val = yv(n0:end) - yv(n0);                    % comeca no mesmo angulo que o modelo
ajuste = 100*(1 - norm(y_val - y_sim)/norm(y_val - mean(y_val)));
tv = (0:numel(y_val)-1)*Ts;

fig = ieee_figura('pagina', 2.3);
ax = axes(fig); hold(ax, 'on')
plot(ax, tv, y_val, '-', 'Color', [0 0 0], 'LineWidth', 1)
plot(ax, tv, y_sim, '-', 'Color', cVerm,  'LineWidth', 1)
xlabel('Time (s)'), ylabel('Tip angle (deg)'), grid on
legend('Measured', 'Model', 'Location', 'northoutside', 'Orientation', 'horizontal')
text(0.99, 0.9, sprintf('Fit = %.1f %%', ajuste), 'Units', 'normalized', ...
    'HorizontalAlignment', 'right')
xlim([0 tv(end)])
ieee_guarda(fig, 'q3_validacao')
fprintf('Ajuste na validacao: %.1f %%\n', ajuste)

%% Fig. 6 - Resposta ao degrau da dinamica identificada (sem integrador)
% A saida do ARMAX e a velocidade da ponta (derivada, em graus por amostra);
% divide-se por Ts para a ter em graus/s. A fase inicial mostra a resposta
% inversa do zero de fase nao minima.
N = round(1/Ts);
yd = filter(Mi.num1, Mi.den1, ones(N, 1))/Ts;
td = (0:N-1)'*Ts;

fig = ieee_figura('coluna', 2.6);
ax = axes(fig); hold(ax, 'on')
stairs(ax, td, yd, 'Color', cAzul, 'LineWidth', LW)
yline(yd(end), '-', 'Color', cCinza, 'LineWidth', 0.5);
xlabel('Time (s)'), ylabel('Tip angular rate (deg/s)'), grid on
xlim([0 1]), ylim([-100 20])
ieee_guarda(fig, 'q3_step')

%% Funcao local: curva de ajuste com o caso adotado destacado
function curva_revisao(x, y, adotado, cAzul, cVerm, LW)
% Curva do ajuste com o caso adotado destacado (quadrado laranja)
hold on
plot(x, y, '-o', 'Color', cAzul, 'LineWidth', LW, 'MarkerSize', 5, 'MarkerFaceColor', 'w', ...
    'HandleVisibility', 'off')
plot(x(adotado), y(adotado), 's', 'Color', cVerm, 'MarkerFaceColor', cVerm, ...
    'MarkerSize', 6, 'HandleVisibility', 'off');
grid on
end
