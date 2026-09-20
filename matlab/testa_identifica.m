%% Teste do script identifica.m com dados sinteticos (modelo conhecido)
% Simula uma planta conhecida, grava os dados no formato do L4 e confirma que
% o identifica.m recupera os polos. Usa o u_prbs.mat (correr gera_prbs antes).
%
% Planta sintetica (velocidade): G(z) = (0.05 z^-1 + 0.04 z^-2) / (1 - 2 r cos(w) z^-1 + r^2 z^-2)
% Posicao = integrador aplicado a G*u. O identifica.m diferencia e filtra
% com af = 0.8, por isso o modelo identificado (na = 3, nb = 2) deve ter os
% 2 polos de G e ainda um polo em af = 0.8.

Ts = 0.02;  af = 0.8;
Kp = 30;    Ke = 5;                 % constantes de calibracao "conhecidas"

S = load('u_prbs.mat');
u = S.u_prbs(:,2);
t = S.u_prbs(:,1);

r = 0.955;  w = 0.1863;             % polos 0.955*exp(+-j 0.1863) (cerca de 1.5 Hz)
den = [1 -2*r*cos(w) r^2];
num = [0 0.05 0.04];
v = filter(num, den, u);            % "velocidade" da barra
y = filter(1, [1 -1], v);           % posicao = integral da velocidade
y = y + 1e-3*randn(size(y));        % ruido de medicao

% Reparte a posicao entre potenciometro e extensometro (ytrend = thetae*Kp + alphae*Ke)
thetae = 0.7*y/Kp;
alphae = 0.3*y/Ke;

dados.time = t;
dados.signals.values = [u thetae alphae];
dados.signals.dimensions = 3;
save('sint_dados.mat', 'dados');

[A, B, C, D, th] = identifica('sint_dados.mat', Kp, Ke, [3 2 3 1], 5);

%% Verificacoes
[den1, ~] = polydata(th);
if iscell(den1), den1 = den1{1}; end
polos      = roots(den1);
esperados  = [roots(den); af];
erro = zeros(size(esperados));
for k = 1:numel(esperados)
    erro(k) = min(abs(polos - esperados(k)));
end
fprintf('\n  polos esperados: %s\n', mat2str(esperados.', 4));
fprintf('  polos obtidos:   %s\n', mat2str(polos.', 4));
fprintf('  erro maximo:     %.4f\n', max(erro));

if max(erro) < 0.03
    disp('  [OK]   o identifica.m recupera o modelo conhecido')
else
    disp('  [FALHA] os polos obtidos nao correspondem aos esperados')
end

polos_ss = eig(A);
if any(abs(polos_ss - 1) < 1e-3)
    disp('  [OK]   o modelo de estados tem o integrador (polo em 1)')
else
    disp('  [FALHA] falta o polo em 1 no modelo de estados')
end
delete('sint_dados.mat')
