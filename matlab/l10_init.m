%% L10 - Parametros para o diagrama Simulink do LQG
% Carrega o modelo (L7), o ganho LQ (L8) e calcula o ganho de Kalman (L9),
% deixando no workspace tudo o que os blocos Gain, Unit Delay e Step usam.
% Corre-se antes de abrir o diagrama. Requer l8_lq.m ja corrido.
% Guarda tudo em ../models/lqg.mat.

F = load('../models/final.mat');
A = F.A; B = F.B; C = F.C; D = F.D; Ts = F.Ts;
n = size(A, 1);

L = load('../models/lq.mat');
K = L.K;                     % ganho LQ (1 x n), u = -K*xh + Nbar*r
Nbar = L.Nbar;               % pre-filtro, ganho 1 de r para y
Nx = L.Nx; Nu = L.Nu;        % estado e entrada de equilibrio por unidade de r

% Kalman: Qw e Rv como botoes de projeto (LTR), nao ruido real
Qw = 100*eye(n);
Rv = 1;
M = dlqe(A, eye(n), C, Qw, Rv);   % ganho do observador corrente (n x 1)

% Calibracoes dos sensores [graus/V] e condicoes do ensaio
Kp = -32.99;                 % potenciometro (identificacao.m)
Ke = 3.9675;                 % extensometro (calibra_ke.txt)
zona_morta = 0.22;           % [V], medida no L4
sat = 1;                     % saturacao do comando [V], a subir com cuidado
r_amp = 5;                   % amplitude da referencia [graus]

save('../models/lqg.mat', 'A', 'B', 'C', 'D', 'Ts', 'K', 'M', 'Nbar', 'Nx', 'Nu', ...
    'Qw', 'Rv', 'Kp', 'Ke', 'zona_morta', 'sat', 'r_amp')

% Verificacoes de dimensao: o Simulink falha em silencio se estas estiverem erradas
assert(isequal(size(A), [n n]) && isequal(size(B), [n 1]) && isequal(size(C), [1 n]))
assert(isequal(size(K), [1 n]) && isequal(size(M), [n 1]) && isscalar(Nbar))
% Verificacao de estabilidade: polos de A-BK e do observador dentro do circulo unitario
assert(all(abs(eig(A - B*K)) < 1), 'A-BK instavel')
assert(all(abs(eig((eye(n) - M*C)*A)) < 1), 'observador instavel')

format long g
disp('A ='), disp(A), disp('B ='), disp(B), disp('C ='), disp(C), disp('D ='), disp(D)
disp('K ='), disp(K), disp('M ='), disp(M)
fprintf('Nbar = %.10g  (Nu = %.4g, Nx'' = %s)\n', Nbar, Nu, mat2str(Nx', 5))
fprintf('Ts = %g s,  Kp = %g,  Ke = %g\n', Ts, Kp, Ke)
