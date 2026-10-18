%% Polos do ARMAX em funcao do polo do filtro (L7, verificacao)
% Repete a identificacao de identificacao.m com varios valores do polo do
% filtro af, mantendo as ordens [4 3 4 1], e mostra os polos de cada modelo.
% O polo que acompanha af e o do proprio filtro (a saida e filtrada e a
% entrada nao); os que ficam quietos sao da planta. Nao grava nada.

ficheiro = '../data/exp2_quad_1V.mat';
ordens = [4 3 4 1];     % [na nb nc nk]
Ts = 0.02;              % intervalo de amostragem [s]
Kp = -32.99;            % potenciometro [graus/V]
Ke = 3.9675;            % extensometro [graus/V]
t0 = 5;                 % segundos iniciais descartados
n0 = round(t0/Ts) + 1;

S = load(ficheiro);
u0 = S.dados.signals.values(:, 1);
y0 = S.dados.signals.values(:, 2)*Kp + S.dados.signals.values(:, 3)*Ke;

fprintf('   af   polos do ARMAX (ordenados por parte real)\n')
for af = [0.5 0.6 0.7 0.8 0.9]
    yf = filter((1-af)*[1 -1], [1 -af], y0);
    yf = detrend(yf(n0:end));
    u  = detrend(u0(n0:end));
    th = armax([yf u], ordens);
    [den, ~] = polydata(th);
    p = roots(den);
    [~, o] = sort(real(p)); p = p(o);
    fprintf('  %4.2f  %s\n', af, mat2str(p.', 3))
end
