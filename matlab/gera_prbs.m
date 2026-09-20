function gera_prbs()
%% Gera os sinais PRBS das experiencias 2 e 3 do L4 e verifica-os
% Grava u_prbs.mat e u_val.mat na pasta atual (Current Folder).
% Requer a System Identification Toolbox (idinput), por isso corre-se em casa.
%
% Como o idinput corta o periodo do PRBS a 2001 amostras, a media pode ficar
% longe de zero e o integral do sinal (que o integrador do motor acumula na
% posicao da barra) pode ficar grande. Aqui geramos um periodo completo,
% experimentamos todos os deslocamentos possiveis e ficamos com o que
% cumpre os limites abaixo, escolhendo o de menor excursao.

Ts   = 0.02;
t    = (0:Ts:40)';
N    = numel(t);          % 2001 amostras
amp  = 1;                 % amplitude [V]

max_media  = 0.05;        % |media| maxima [V]
max_integ  = 3.5;         % max |integral de u| maxima [V.s] (quadrada 0.4 Hz: 1.25)

disp(which('idinput'))

u_prbs = [t, escolhe_prbs(N, 0.1,  Ts, amp, max_media, max_integ)];   % experiencia 2
u_val  = [t, escolhe_prbs(N, 0.05, Ts, amp, max_media, max_integ)];   % experiencia 3 (validacao)

save('u_prbs.mat', 'u_prbs');
save('u_val.mat',  'u_val');

a = u_prbs(:,2);
b = u_val(:,2);

%% Verificacoes
falhas = 0;
falhas = falhas + verifica('mesmo numero de amostras (2001) e tempo de 0 a 40 s', ...
    numel(a) == 2001 && numel(b) == 2001 && abs(t(end) - 40) < 1e-9);
falhas = falhas + verifica('sequencias diferentes', ~isequal(a, b));
falhas = falhas + verifica('valores apenas -1 e +1', ...
    isequal(unique(a)', [-1 1]) && isequal(unique(b)', [-1 1]));

ra = duracoes(a, Ts);
rb = duracoes(b, Ts);
fprintf('       patamares em a: min %.2f s, max %.2f s\n', min(ra), max(ra));
fprintf('       patamares em b: min %.2f s, max %.2f s\n', min(rb), max(rb));
falhas = falhas + verifica('patamar minimo de a = 0.2 s e de b = 0.4 s', ...
    abs(min(ra) - 0.2) < 1e-9 && abs(min(rb) - 0.4) < 1e-9);
falhas = falhas + verifica('patamar maximo <= 3.5 s (transitorios excitados)', ...
    max(ra) <= 3.5 && max(rb) <= 3.5);

fprintf('       media a: %.3f   media b: %.3f\n', mean(a), mean(b));
falhas = falhas + verifica(sprintf('|media| < %.2f V', max_media), ...
    abs(mean(a)) < max_media && abs(mean(b)) < max_media);

ia = max(abs(cumsum(a))) * Ts;
ib = max(abs(cumsum(b))) * Ts;
fprintf('       excursao (max |integral de u|): a %.2f V.s, b %.2f V.s\n', ia, ib);
falhas = falhas + verifica(sprintf('excursao < %.1f V.s (deriva da barra limitada)', max_integ), ...
    ia < max_integ && ib < max_integ);

% Formato exigido pelo From Workspace: coluna 1 = tempo, coluna 2 = tensao
falhas = falhas + verifica('formato [tempo, tensao] com 2 colunas', ...
    size(u_prbs,2) == 2 && size(u_val,2) == 2 && all(abs(diff(u_prbs(:,1)) - Ts) < 1e-9));

if falhas == 0
    disp('Todos os sinais verificados: prontos para o laboratorio.')
else
    fprintf('%d verificacao(oes) falharam: NAO usar estes sinais, voltar a correr.\n', falhas);
end

% Graficos (so quando ha ecra)
if usejava('desktop')
    figure;
    subplot(2,1,1), stairs(t, a), grid on, ylabel('u\_prbs [V]'), ylim([-1.5 1.5])
    subplot(2,1,2), stairs(t, b), grid on, ylabel('u\_val [V]'),  ylim([-1.5 1.5])
    xlabel('t [s]')
    figure;
    plot(t, cumsum(a)*Ts, t, cumsum(b)*Ts), grid on
    legend('u\_prbs', 'u\_val'), xlabel('t [s]'), ylabel('\int u dt [V.s]')
end
end

%% Funcoes locais
function u = escolhe_prbs(N, banda, Ts, amp, max_media, max_integ)
% Gera um periodo completo de PRBS com idinput e devolve a versao (deslocada
% em multiplos do patamar) de N amostras que cumpre os limites, com a menor
% excursao. Deslocar o sinal num multiplo do patamar mantem a estrutura PRBS.
c     = round(1 / banda);                % amostras por patamar
M     = 255;                             % periodo de um PRBS de ordem 8
p     = idinput(c * M, 'prbs', [0 banda], [-amp amp]);
melhor = [];
integ_melhor = inf;
for k = 0:M-1
    v = circshift(p, k * c);
    v = v(1:N);
    integ = max(abs(cumsum(v))) * Ts;
    if abs(mean(v)) < max_media && integ < max_integ && integ < integ_melhor
        melhor = v;
        integ_melhor = integ;
    end
end
if isempty(melhor)
    error('Nenhuma realizacao cumpre os limites (banda %.3f). Relaxar max_media/max_integ.', banda);
end
u = melhor;
end

function r = duracoes(x, Ts)
% Duracao [s] de cada patamar, sem o ultimo (que o corte pode deixar incompleto).
r = diff([0; find(diff(x) ~= 0); numel(x)]) * Ts;
r = r(1:end-1);
end

function falha = verifica(texto, condicao)
if condicao
    fprintf('  [OK]   %s\n', texto);
    falha = 0;
else
    fprintf('  [FALHA] %s\n', texto);
    falha = 1;
end
end
