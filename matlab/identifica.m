function [A, B, C, D, th] = identifica(ficheiro, Kp, Ke, ordens, t_descarta)
% IDENTIFICA  Identifica o modelo da barra flexivel a partir de um .mat do L4.
%
%   [A,B,C,D,th] = identifica('exp2_prbs_1V.mat', Kp, Ke)
%   [A,B,C,D,th] = identifica('exp2_prbs_1V.mat', Kp, Ke, [3 2 3 1], 5)
%
% Entradas
%   ficheiro    .mat com a variavel 'dados' (Structure With Time), colunas:
%               1 excitacao [V], 2 potenciometro [V], 3 extensometro [V]
%   Kp, Ke      constantes de calibracao [graus/V]
%   ordens      [na nb nc nk] do armax (por omissao [3 2 3 1])
%   t_descarta  segundos iniciais a descartar (por omissao 5; o guia sugere 5 a 10)
%
% Saidas
%   A,B,C,D     modelo em espaco de estados (tempo discreto) com integrador
%   th          modelo armax da saida diferenciada e filtrada
%
% Segue a Secao 4 do guia: ytrend = thetae*Kp + alphae*Ke, diferenciar e
% filtrar a saida (af = 0.8), detrend, armax, somar o integrador (polo em 1)
% e converter para espaco de estados.

if nargin < 4 || isempty(ordens),     ordens = [3 2 3 1]; end
if nargin < 5 || isempty(t_descarta), t_descarta = 5;     end

Ts = 0.02;

%% 1. Ler os dados
S = load(ficheiro);
if ~isfield(S, 'dados')
    error('O ficheiro %s nao tem a variavel "dados".', ficheiro);
end
t    = S.dados.time(:);
sigs = S.dados.signals.values;
utrend = sigs(:,1);     % excitacao
thetae = sigs(:,2);     % potenciometro
alphae = sigs(:,3);     % extensometro

%% 2. Posicao da ponta da barra
ytrend = thetae*Kp + alphae*Ke;

%% 3. Diferenciar e filtrar a saida (remove o integrador do motor)
af    = 0.8;
Afilt = [1 -af];
Bfilt = (1-af) * [1 -1];
yf    = filter(Bfilt, Afilt, ytrend);

%% 4. Descartar o transitorio inicial e retirar tendencias
n0 = round(t_descarta / Ts) + 1;
yf = detrend(yf(n0:end));
u  = detrend(utrend(n0:end));
tt = t(n0:end);

%% 5. Identificar com armax
z  = [yf u];
nn = ordens;                 % [na nb nc nk]
th = armax(z, nn);
[den1, num1] = polydata(th);
if iscell(den1), den1 = den1{1}; end
if iscell(num1), num1 = num1{1}; end

%% 6. Validacao: resposta do modelo contra a saida diferenciada e filtrada
yfsim = filter(num1, den1, u);
ajuste = 100 * (1 - norm(yf - yfsim) / norm(yf - mean(yf)));
fprintf('\n%s\n', ficheiro);
fprintf('  ordens [na nb nc nk] = [%d %d %d %d], ajuste = %.1f %%\n', nn, ajuste);
fprintf('  polos do modelo (antes do integrador): %s\n', mat2str(roots(den1).', 4));

figure;
plot(tt, yf, tt, yfsim), grid on
legend('dados (diferenciados e filtrados)', 'modelo'), xlabel('t [s]'), ylabel('y_f')
title(sprintf('%s, ajuste %.1f %%', ficheiro, ajuste), 'Interpreter', 'none')

%% 7. Somar o integrador e converter para espaco de estados
[num, den] = eqtflength(num1, conv(den1, [1 -1]));
[A, B, C, D] = tf2ss(num, den);
end
