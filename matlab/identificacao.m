function [th, ajuste] = identificacao(ficheiro_id, ficheiro_val)

if nargin < 2, ficheiro_val = '../data/exp2_val_1V.mat'; end

%% Parametros 
Ts = 0.02;              % intervalo de amostragem [s]
Kp = -32.99;            % potenciometro [graus/V]
Ke = 3.9675;            % extensometro [graus/V]
af = 0.8;               % polo do filtro da saida
t0 = 5;                 % segundos iniciais descartados

na = 3; nb = 2; nc = 3; nk = 1;     % ordens do ARMAX 

% na - memoria de saida: quanto valores de saida y entram na eq
% nb - quantos valores de entrada u entram
% n_k - o atraso puro (delay), numeros de passos que a entrada demora a
% fazer efeito 
% nc - memoria do ruido. Com nc = 0m o ruido a cada instante e independente


%% Dados de identificacao
S = load(ficheiro_id);
t      = S.dados.time;
sigs   = S.dados.signals.values;
utrend = sigs(:, 1);                % excitacao [V]
thetae = sigs(:, 2);                % potenciometro [V]
alphae = sigs(:, 3);                % extensometro [V]

% Posicao da ponta da barra
ytrend = thetae*Kp + alphae*Ke; %Com as conveçoes corretas, de ACW positive dir 

% Derivar e filtrar a saida (remove o integrador do motor)
Afilt = [1 -af]; cd c
Bfilt = (1-af) * [1 -1];
yf = filter(Bfilt, Afilt, ytrend);

% Descartar o inicio e retirar tendencias
n0 = round(t0/Ts) + 1;
yf = detrend(yf(n0:end));
u  = detrend(utrend(n0:end));

%% ARMAX
z  = [yf u];
th = armax(z, [na nb nc nk])
[den1, num1] = polydata(th);

%% Validacao com dados que nao foram usados na identificacao
V   = load(ficheiro_val);
sv  = V.dados.signals.values;
yv  = filter(Bfilt, Afilt, sv(:, 2)*Kp + sv(:, 3)*Ke);
yv  = detrend(yv(n0:end));
uv  = detrend(sv(n0:end, 1));

yfsim = filter(num1, den1, uv);
ajuste = 100 * (1 - norm(yv - yfsim) / norm(yv - mean(yv)));

figure
tv = (n0-1:n0-1+numel(yv)-1)' * Ts;
plot(tv, yv, tv, yfsim), grid on
xlabel('t [s]'), ylabel('y_f'), legend('validacao', 'modelo')
title(sprintf('ARMAX [%d %d %d %d], ajuste %.1f %%', na, nb, nc, nk, ajuste))
end
