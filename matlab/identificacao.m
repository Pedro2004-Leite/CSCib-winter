%% Identificacao ARMAX do sistema motor + barra (L5)
% Le os dados do L4, processa-os como pede a Seccao 4 do guia e identifica
% o modelo ARMAX. Experimenta varias ordens (na, nb, nc) e fica com a que
% melhor ajusta os dados de validacao.

%% Parametros
Ts = 0.02;              % intervalo de amostragem [s]
Kp = -32.99;            % potenciometro [graus/V]
Ke = 3.9675;            % extensometro [graus/V]
af = 0.8;               % polo do filtro da saida
t0 = 5;                 % segundos iniciais descartados
n0 = round(t0/Ts) + 1;

%% Dados de identificacao
ficheiro_id = '../data/exp_sinewave.mat';  % trocar para outro ficheiro se preciso
[~, nome_id] = fileparts(ficheiro_id);
S = load(ficheiro_id);
utrend = S.dados.signals.values(:, 1);  % excitacao [V]
thetae = S.dados.signals.values(:, 2);  % potenciometro [V]
alphae = S.dados.signals.values(:, 3);  % extensometro [V]

% Posicao da ponta da barra, diferenciada e filtrada (remove o integrador
% do motor e atenua o ruido de alta frequencia)
ytrend = thetae*Kp + alphae*Ke;
Afilt = [1 -af];
Bfilt = (1-af)*[1 -1];
yf = filter(Bfilt, Afilt, ytrend);

% Descartar o inicio e retirar tendencias
yf = detrend(yf(n0:end));
u  = detrend(utrend(n0:end));

%% Dados de validacao (nunca usados na identificacao)
V  = load('../data/exp2_val_1V.mat');
sv = V.dados.signals.values;
yv = filter(Bfilt, Afilt, sv(:,2)*Kp + sv(:,3)*Ke);
yv = detrend(yv(n0:end));
uv = detrend(sv(n0:end, 1));

%% Escolha das ordens: ajuste do modelo aos dados de validacao
% Grelha estendida para alem da zona de plateau: na ate 6 e nb ate 4 para
% mostrar que o ajuste satura e justificar a escolha de [4 3 4] por
% parcimonia (a planta tem ~4 estados: motor + modos da barra). A tabela
% completa fica registada no ficheiro de ordens, mas o modelo final NAO e
% o maximo da grelha: o ganho acima de [4 3 4] e inferior a 1 %, da ordem
% do ruido do ajuste, e nao justifica os estados extra na Seccao 5 (LQG).
ordens = [4 3 4 1];   % [na nb nc nk] fixadas na revisao do L7
linhas = {'  na  nb  nc    ajuste [%]'};
fprintf('%s\n', linhas{1});
for na = 2:6
    for nb = 1:4
        nc = na;
        th_i = armax([yf u], [na nb nc ordens(4)]);
        [den_i, num_i] = polydata(th_i);
        ysim = filter(num_i, den_i, uv);
        fit_i = 100*(1 - norm(yv-ysim)/norm(yv-mean(yv)));
        linhas{end+1} = sprintf('  %2d  %2d  %2d     %5.1f', na, nb, nc, fit_i);
        fprintf('%s\n', linhas{end});
    end
end

%% Modelo final (ordens fixadas na revisao, nao o maximo da grelha)
na = ordens(1); nb = ordens(2); nc = ordens(3); nk = ordens(4);
fprintf('Escolhido: na=%d, nb=%d, nc=%d (fixado na revisao do L7)\n', na, nb, nc)
z  = [yf u];
th = armax(z, [na nb nc nk])
[den1, num1] = polydata(th);

%% Comparacao com os dados de validacao
yfsim = filter(num1, den1, uv);
ajuste = 100*(1 - norm(yv-yfsim)/norm(yv-mean(yv)));

figure
tv = (0:numel(yv)-1)*Ts;
plot(tv, yv, tv, yfsim), grid on
xlabel('t [s]'), ylabel('y_f')
legend('validacao', 'modelo')
title(sprintf('ARMAX [%d %d %d %d], ajuste %.1f %%', na, nb, nc, nk, ajuste))

% Guardar grafico, tabela de ordens e modelo (para o L6), com o nome do ficheiro de treino
if ~exist('../results', 'dir'), mkdir('../results'); end
saveas(gcf, sprintf('../results/%s.png', nome_id))
fid = fopen(sprintf('../results/%s_ordens.txt', nome_id), 'w');
fprintf(fid, '%s\n', linhas{:});
fprintf(fid, 'Escolhido: na=%d, nb=%d, nc=%d (ajuste %.1f %%)\n', na, nb, nc, ajuste);
fclose(fid);

if ~exist('../models', 'dir'), mkdir('../models'); end
save(sprintf('../models/%s.mat', nome_id), 'num1', 'den1', 'Ts')
