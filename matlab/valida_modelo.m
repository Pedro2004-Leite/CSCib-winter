%% 
%% Validacao do modelo (L6, tarefa 3)
% Le o modelo de espaco de estados de models/, simula-o e compara-o com os
% dados de validacao (a) e com os dados de identificacao (b). Mostra tambem
% a resposta em frequencia (c). Guarda os graficos em results/ e acrescenta
% os ajustes a results/resumo.txt.

ficheiro = 'exp2_quad_1V.mat';   % trocar para outro modelo se preciso
[~, nome] = fileparts(ficheiro);

%% Modelo
S = load(['../models/ss_' ficheiro]);
num = S.num; den = S.den; Ts = S.Ts;

%% Parametros (iguais aos da identificacao)
Kp = -32.99;            % potenciometro [graus/V]
Ke = 3.9675;            % extensometro [graus/V]
t0 = 5;                 % segundos iniciais descartados
n0 = round(t0/Ts) + 1;

%% (a) Comparacao com os dados de validacao (nunca usados na identificacao)
V = load('../data/exp2_val_1V.mat');
sv = V.dados.signals.values;
uv = sv(:,1);
yv = sv(:,2)*Kp + sv(:,3)*Ke;

y_sim = filter(num, den, uv(n0:end));
y_val = yv(n0:end) - yv(n0);        % comeca no mesmo angulo que o modelo
ajuste = 100*(1 - norm(y_val-y_sim)/norm(y_val-mean(y_val)));

tv = (0:numel(y_val)-1)*Ts;

% Ajuste sem a deriva linear (a deriva do cabo nao e modelada)
yr = y_val - polyval(polyfit(tv', y_val, 1), tv');
sr = y_sim - polyval(polyfit(tv', y_sim, 1), tv');
ajuste_d = 100*(1 - norm(yr-sr)/norm(yr-mean(yr)));

figure
plot(tv, y_val, tv, y_sim), grid on
xlabel('t [s]'), ylabel('angulo da ponta [graus]')
legend('validacao', 'modelo')
title(sprintf('Validacao - ajuste %.1f %%', ajuste))
if ~exist('../results', 'dir'), mkdir('../results'); end
saveas(gcf, sprintf('../results/%s_validacao.png', nome))

%% (b) Resposta temporal simulada com a excitacao de identificacao
Id = load(['../data/' ficheiro]);
sd = Id.dados.signals.values;
ud = sd(:,1);
yd = sd(:,2)*Kp + sd(:,3)*Ke;

y_sim2 = filter(num, den, ud(n0:end));
y_id   = yd(n0:end) - yd(n0);
ajuste_sim = 100*(1 - norm(y_id-y_sim2)/norm(y_id-mean(y_id)));

yr2 = y_id   - polyval(polyfit(tv', y_id, 1), tv');
sr2 = y_sim2 - polyval(polyfit(tv', y_sim2, 1), tv');
ajuste_sim_d = 100*(1 - norm(yr2-sr2)/norm(yr2-mean(yr2)));

figure
plot(tv, y_id, tv, y_sim2), grid on
xlabel('t [s]'), ylabel('angulo da ponta [graus]')
legend('medido', 'modelo')
title(sprintf('Simulacao com a excitacao de identificacao (%s) - ajuste %.1f %%', nome, ajuste_sim), 'Interpreter', 'none')
saveas(gcf, sprintf('../results/%s_simulacao.png', nome))

%% (c) Resposta em frequencia (o bode de um sistema discreto vai ate Nyquist = 25 Hz)
sys = tf(num, den, Ts);
figure
bode(sys), grid on
saveas(gcf, sprintf('../results/%s_bode.png', nome))

% Ganho estatico da dinamica identificada (a planta completa tem o
% integrador, logo ganho DC infinito)
M = load(['../models/' ficheiro]);
k_est = polyval(M.num1, 1)/polyval(M.den1, 1)/Ts;   % [graus/s por V]

% Fase no cruzamento de 0 dB, a partir da margem de fase da planta
[~, Pm, Wcg, ~] = margin(sys);
fase_0dB = Pm - 180;
if isempty(Wcg), Wcg = NaN; fase_0dB = NaN; end

fprintf('Ajuste validacao: %.1f %% (sem deriva: %.1f %%)\n', ajuste, ajuste_d)
fprintf('Ajuste simulacao (dados de treino): %.1f %% (sem deriva: %.1f %%)\n', ajuste_sim, ajuste_sim_d)
fprintf('Ganho estatico (sem integrador): %.2f graus/s por V\n', k_est)
fprintf('Fase em 0 dB: %.1f graus em %.3f rad/s\n', fase_0dB, Wcg)

% Acrescenta os ajustes ao resumo em results/resumo.txt
fid = fopen('../results/resumo.txt', 'a');
fprintf(fid, '--- L6: %s ---\n', nome);
fprintf(fid, '  Ajuste validacao (dados nunca usados): %.1f %%\n', ajuste);
fprintf(fid, '  Ajuste simulacao (dados de treino):    %.1f %%\n', ajuste_sim);
fprintf(fid, '  Sem deriva linear: validacao %.1f %%, treino %.1f %%\n', ajuste_d, ajuste_sim_d);
fprintf(fid, '  Ganho estatico (sem integrador): %.2f graus/s por V\n', k_est);
fprintf(fid, '  Fase em 0 dB: %.1f graus em %.3f rad/s\n', fase_0dB, Wcg);
fclose(fid);
