function verifica_dados(ficheiro, amp_esperada)
% VERIFICA_DADOS  Verifica a qualidade de um ficheiro .mat gravado no L4.
%
%   verifica_dados('exp1_quad_1V.mat')
%   verifica_dados('exp5_quad_grande.mat', 2)   % com amplitude esperada [V]
%
% O ficheiro deve conter a variavel 'dados' (Structure With Time), com as
% colunas: 1 excitacao, 2 potenciometro, 3 extensometro.

Ts = 0.02;      % periodo de amostragem esperado [s]
N  = 2001;      % numero de amostras esperado

S = load(ficheiro);
if ~isfield(S, 'dados')
    error('O ficheiro %s nao tem a variavel "dados".', ficheiro);
end
t = S.dados.time(:);
s = S.dados.signals.values;

fprintf('\n%s\n', ficheiro);

% 1. Dimensoes
verifica(size(s,2) == 3 && size(s,1) == N, ...
    sprintf('dimensoes %d x %d (esperado %d x 3)', size(s,1), size(s,2), N));
if size(s,2) < 3
    error('Faltam colunas: nao da para continuar.');
end

% 2. Passo temporal constante
dt = max(abs(diff(t) - Ts));
verifica(dt < 1e-4, sprintf('passo temporal constante em %.3f s (desvio max. %.2g s)', Ts, dt));

% 3. Valores invalidos
verifica(~any(isnan(s(:))) && ~any(isinf(s(:))), 'sem NaN nem Inf');

% 4. Excitacao
u = s(:,1);
fprintf('       excitacao: min %.3f V, max %.3f V\n', min(u), max(u));
if nargin >= 2
    verifica(abs(max(abs(u)) - amp_esperada) < 0.05*amp_esperada, ...
        sprintf('amplitude da excitacao ~ %.2f V', amp_esperada));
end

% 5. Potenciometro: sem salto de extremo a extremo (barra nao deu volta)
verifica(~any(abs(diff(s(:,2))) > 5), ...
    'potenciometro sem salto (a barra nao deu uma volta completa)');

% 6. Saturacao dos A/D (gama de -10 a 10 V)
verifica(all(all(abs(s(:,2:3)) < 9.9)), 'sensores sem saturacao em +-10 V');

% 7. Extensometro nao constante (cabo solto ou canal errado)
fprintf('       extensometro: min %.3f V, max %.3f V, desvio padrao %.4f V\n', ...
    min(s(:,3)), max(s(:,3)), std(s(:,3)));
verifica(std(s(:,3)) > 0.01, ...
    'extensometro nao constante (normal ser baixo na amplitude pequena)');

% Graficos
figure;
subplot(3,1,1), plot(t, s(:,1)), grid on, ylabel('u [V]')
title(ficheiro, 'Interpreter', 'none')
subplot(3,1,2), plot(t, s(:,2)), grid on, ylabel('\theta_e [V]')
subplot(3,1,3), plot(t, s(:,3)), grid on, ylabel('\alpha_e [V]')
xlabel('t [s]')
end

function verifica(condicao, texto)
if condicao
    fprintf('  [OK]   %s\n', texto);
else
    fprintf('  [FALHA] %s\n', texto);
end
end
