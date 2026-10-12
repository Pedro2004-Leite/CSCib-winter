%% Conversao do modelo ARMAX para espaco de estados (L6)
% Le o modelo guardado em models/, acrescenta o integrador do motor que foi
% removido dos dados (tarefa 1) e converte para espaco de estados (tarefa
% 2). O resultado fica guardado em models/ss_<nome>.mat.

ficheiro = 'exp_sinewave.mat';   % trocar para outro modelo se preciso
S = load(['../models/' ficheiro]);
num1 = S.num1;
den1 = S.den1;
Ts   = S.Ts;

%% Tarefa 1: acrescentar o integrador do motor (polo em z = 1)
[num, den] = eqtflength(num1, conv(den1, [1 -1]));

%% Tarefa 2: modelo de espaco de estados
[A, B, C, D] = tf2ss(num, den);

disp('A ='), disp(A)
disp('B ='), disp(B)
disp('C ='), disp(C)
disp('D ='), disp(D)

[~, nome] = fileparts(ficheiro);
save(['../models/ss_' nome '.mat'], 'A', 'B', 'C', 'D', 'num', 'den', 'Ts')
