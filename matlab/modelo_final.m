%% Modelo final (L7, tarefa 3)
% Fixa as matrizes A, B, C, D que seguem para a Seccao 5 (guardadas em
% models/final.mat) e regista o diagrama de polos/zeros, a resposta em
% frequencia e a resposta temporal. Graficos em results/.

ficheiro = 'exp2_quad_1V.mat';   % modelo escolhido na revisao
[~, nome] = fileparts(ficheiro);

S = load(['../models/ss_' ficheiro]);
A = S.A; B = S.B; C = S.C; D = S.D;
num = S.num; den = S.den; Ts = S.Ts;

% Unico ficheiro que a Seccao 5 precisa de ler
save('../models/final.mat', 'A', 'B', 'C', 'D', 'num', 'den', 'Ts');

sys = tf(num, den, Ts);

% Diagrama de polos e zeros
figure
pzmap(sys), grid on
saveas(gcf, '../results/final_pzmap.png')

% Resposta em frequencia
figure
bode(sys), grid on
saveas(gcf, '../results/final_bode.png')

% Resposta temporal: como a planta tem integrador, o degrau da planta
% completa diverge. Mostra-se o degrau da dinamica identificada (sem
% integrador), que assenta no ganho estatico de velocidade.
M = load(['../models/' ficheiro]);
figure
step(tf(M.num1, M.den1, Ts)), grid on
title('Resposta ao degrau da dinamica identificada (sem integrador)')
saveas(gcf, '../results/final_step.png')

% Caracterizacao para o relatorio
k_est = polyval(M.num1, 1)/polyval(M.den1, 1)/Ts;   % [graus/s por V]
[~, Pm, ~, Wcp] = margin(sys);   % Wcp: frequencia a que o ganho cruza 0 dB
disp('Polos:'), disp(eig(A))
disp('Zeros:'), disp(roots(M.num1))
fprintf('Ganho estatico (sem integrador): %.2f graus/s por V\n', k_est)
if ~isempty(Wcp)
    fprintf('Fase em 0 dB: %.1f graus em %.3f rad/s\n', Pm-180, Wcp)
end

fid = fopen('../results/resumo.txt', 'a');
fprintf(fid, '--- L7: modelo final (%s) ---\n', nome);
fprintf(fid, '  Matrizes A, B, C, D em models/final.mat\n');
fprintf(fid, '  Polos: %s\n', mat2str(eig(A)', 4));
fprintf(fid, '  Zeros: %s\n', mat2str(roots(M.num1)', 4));
fprintf(fid, '  Ganho estatico (sem integrador): %.2f graus/s por V\n', k_est);
if ~isempty(Wcp)
    fprintf(fid, '  Fase em 0 dB: %.1f graus em %.3f rad/s\n', Pm-180, Wcp);
end
fclose(fid);
