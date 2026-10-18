%% Calibracao do extensometro, Ke (Q2)
% Adaptado de calculate_ke.m. Le o ensaio com o pente (data/input_strain.mat):
% a barra e deslocada por ranhuras sucessivas e a tensao do extensometro
% assenta em patamares. Para cada patamar calcula-se a tensao media e o
% angulo de deflexao da ponta; Ke e o declive da reta que passa pela origem
% e melhor ajusta os pontos (minimos quadrados).
% Grava a figura em ../report/Figs (q2_ke) e os resultados em results/calibra_ke.txt.

ficheiro = '../data/input_strain.mat';
L = 0.42;                       % comprimento da barra, medido [m]
passo = 0.25*2.54/100;          % ranhuras afastadas de 1/4 de polegada [m]
ranhuras = [0 1 2 3 4 5 6 7 0 -1 -2 -3 -4 -5 -6 -7 0]';   % sequencia do ensaio

S = load(ficheiro);
t = S.input.time(:);
v = S.input.signals.values(:);
Ts = median(diff(t));

%% Patamares: zonas onde o desvio padrao local e baixo
k = max(round(0.3/Ts), 3);
m1 = conv(v, ones(k,1)/k, 'same');
m2 = conv(v.^2, ones(k,1)/k, 'same');
dp_local = sqrt(max(m2 - m1.^2, 0));
limiar = max(3*median(dp_local), 0.005);

estavel = dp_local < limiar;
d = diff([0; estavel; 0]);
ini = find(d == 1);
fim = find(d == -1) - 1;

n_min = round(2/Ts);            % patamar com pelo menos 2 s
n_corte = round(0.5/Ts);        % descartar 0.5 s em cada ponta (transitorios)
ok = (fim - ini) >= n_min;
ini = ini(ok) + n_corte;
fim = fim(ok) - n_corte;
n = numel(ini);
if n ~= numel(ranhuras)
    error('Encontrados %d patamares, esperados %d. Verificar o sinal.', n, numel(ranhuras))
end

v_med = zeros(n, 1);
for i = 1:n
    v_med(i) = mean(v(ini(i):fim(i)));
end

%% Deflexao da ponta e ajuste
alfa = (ranhuras*passo/L)*180/pi;       % angulo [graus]
Ke = v_med \ alfa;                      % minimos quadrados, reta pela origem
res = alfa - Ke*v_med;                  % residuos [graus]
R2 = 1 - sum(res.^2)/sum((alfa - mean(alfa)).^2);
fprintf('Ke = %.4f graus/V\nErro maximo %.2f graus, rms %.2f graus, R2 = %.3f\n', ...
    Ke, max(abs(res)), sqrt(mean(res.^2)), R2)

if ~exist('../results', 'dir'), mkdir('../results'); end
fid = fopen('../results/calibra_ke.txt', 'w');
fprintf(fid, 'Calibracao do extensometro (data/input_strain.mat)\n');
fprintf(fid, 'L = %.2f m, passo = %.5f m, %d patamares\n', L, passo, n);
fprintf(fid, 'Ke = %.4f graus/V\n', Ke);
fprintf(fid, 'Erro maximo %.2f graus, rms %.2f graus, R2 = %.3f\n', max(abs(res)), sqrt(mean(res.^2)), R2);
fprintf(fid, '  ranhura   tensao [V]   angulo [graus]   residuo [graus]\n');
fprintf(fid, '  %5d     %8.3f     %8.2f        %8.2f\n', [ranhuras v_med alfa res]');
fclose(fid);

%% Figura (estilo IEEE, ver ieee_figura.m e ieee_guarda.m)
cAzul = [0 0.45 0.70];
cVerm = [0.84 0.37 0];
cCinza = [0.4 0.4 0.4];
LW = 1.25;

fig = ieee_figura('pagina', 3.0);
tl = tiledlayout(1, 5, 'TileSpacing', 'compact', 'Padding', 'compact');

% (a) Tensao no tempo, com os patamares usados a vermelho e a ranhura de cada um
nexttile(tl, 1, [1 3]), hold on
plot(t, v, '-', 'Color', cAzul, 'LineWidth', 0.75)
for i = 1:n
    plot(t(ini(i):fim(i)), v(ini(i):fim(i)), '-', 'Color', cVerm, 'LineWidth', 2)
    text(mean(t([ini(i) fim(i)])), v_med(i) + 0.28 - 0.56*(ranhuras(i) < 0), ...
        sprintf('%d', ranhuras(i)), 'HorizontalAlignment', 'center')
end
xlabel('Time (s)'), ylabel('Strain-gage voltage αₑ (V)'), grid on
xlim([0 t(end)]), ylim([-2.4 2.4])
text(0.01, 0.94, '(a)', 'Units', 'normalized')
text(0.99, 0.94, 'numbers: comb slot', 'Units', 'normalized', 'HorizontalAlignment', 'right')

% (b) Pontos medidos e reta ajustada
nexttile(tl, 4, [1 2]), hold on
vv = [min(v_med) max(v_med)]*1.1;
plot(vv, Ke*vv, '-', 'Color', cCinza, 'LineWidth', 1)
plot(v_med, alfa, 'o', 'Color', cAzul, 'MarkerFaceColor', cAzul, 'MarkerSize', 5)
xlabel('Mean voltage αₑ (V)'), ylabel('Deflection angle α (deg)'), grid on
text(0.96, 0.1, sprintf('Kₑ = %.2f deg/V', Ke), 'Units', 'normalized', 'HorizontalAlignment', 'right', 'Color', cCinza)
text(0.04, 0.94, '(b)', 'Units', 'normalized')
ieee_guarda(fig, 'q2_ke')
