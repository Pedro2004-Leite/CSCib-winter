%% Revisao da identificacao (L7, tarefa 1)
% Varia o polo do filtro, as ordens do modelo e o periodo de amostragem e
% compara os modelos obtidos nos dados de validacao. A tabela e mostrada na
% consola e acrescentada a results/resumo.txt.

ficheiro = 'exp2_quad_1V.mat';   % trocar para outro ficheiro se preciso
[~, nome] = fileparts(ficheiro);

%% Parametros base
Ts = 0.02;      % intervalo de amostragem [s]
Kp = -32.99;    % potenciometro [graus/V]
Ke = 3.9675;    % extensometro [graus/V]
t0 = 5;         % segundos iniciais descartados

%% Dados em bruto
S = load(['../data/' ficheiro]);
sd = S.dados.signals.values;
ud = sd(:,1);                       % excitacao [V]
yd = sd(:,2)*Kp + sd(:,3)*Ke;       % angulo da ponta [graus]

V = load('../data/exp2_val_1V.mat');
sv = V.dados.signals.values;
uv = sv(:,1);
yv = sv(:,2)*Kp + sv(:,3)*Ke;

%% Variacoes: filtro (af), ordens (na, nb) e amostragem (fator de dizimacao)
% O ajuste e sempre medido nos dados de validacao, processados da mesma
% maneira que na identificacao. A linha "base" deve reproduzir o ajuste
% escolhido no L5.
variacoes = { ...
    'base',          0.8, 4, 3, 1;
    'filtro af=0.5', 0.5, 4, 3, 1;
    'filtro af=0.9', 0.9, 4, 3, 1;
    'ordens [3 3]',  0.8, 3, 3, 1;
    'ordens [5 3]',  0.8, 5, 3, 1;
    'ordens [4 2]',  0.8, 4, 2, 1;
    'Ts = 0.04 s',   0.8, 4, 3, 2;
    'Ts = 0.06 s',   0.8, 4, 3, 3;
    };

linhas = {'  variacao       af   na  nb    Ts       ajuste [%]'};
fprintf('%s\n', linhas{1});
for k = 1:size(variacoes, 1)
    v    = variacoes(k, :);
    af_i = v{2}; na_i = v{3}; nb_i = v{4}; dec = v{5};
    Ts_i = Ts*dec;
    n0   = round(t0/Ts_i) + 1;

    % Processar identificacao e validacao da mesma maneira (Seccao 4 do guia)
    udi = ud(1:dec:end); ydi = yd(1:dec:end);
    Afilt = [1 -af_i];
    Bfilt = (1-af_i)*[1 -1];
    yf = filter(Bfilt, Afilt, ydi);
    yf = detrend(yf(n0:end));
    uf = detrend(udi(n0:end));

    uvi = uv(1:dec:end); yvi = yv(1:dec:end);
    yvf = filter(Bfilt, Afilt, yvi);
    yvf = detrend(yvf(n0:end));
    uvf = detrend(uvi(n0:end));

    th_i  = armax([yf uf], [na_i nb_i na_i 1]);
    [den_i, num_i] = polydata(th_i);
    ysim = filter(num_i, den_i, uvf);
    fit_i = 100*(1 - norm(yvf-ysim)/norm(yvf-mean(yvf)));

    linhas{end+1} = sprintf('  %-14s %4.2f %3d %3d  %5.2f       %5.1f', v{1}, af_i, na_i, nb_i, Ts_i, fit_i);
    fprintf('%s\n', linhas{end});
end

fid = fopen('../results/resumo.txt', 'a');
fprintf(fid, '--- L7: revisao (%s) ---\n', nome);
fprintf(fid, '%s\n', linhas{:});
fclose(fid);
