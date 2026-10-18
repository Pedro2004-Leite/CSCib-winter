function ieee_guarda(fig, nome)
% IEEE_GUARDA  Aplica o estilo IEEE a uma figura e exporta-a para ../report/Figs.
% Estilo (IEEE Author Center, "Create graphics for your article"):
%   - um unico tipo de letra (Times se existir, senao Arial ou DejaVu Sans) e um unico tamanho (11 pt, o do corpo do texto) em
%     eixos, rotulos, legendas e anotacoes;
%   - sem titulo na figura (a legenda "Fig. N." fica no documento);
%   - linhas continuas e grossas para os dados, eixos finos, grelha cinzenta clara;
%   - ficheiro vetorial PDF (letras embebidas) e PNG a 600 dpi.
% Requer uma versao recente do MATLAB (exportgraphics com 'Padding', R2022a ou posterior).

TAM = 11;                                    % tamanho do texto [pt], igual ao corpo do texto (11 pt)
% Letras realmente instaladas: em Linux, listfonts inclui nomes que nao existem
% (por exemplo Times, Helvetica), por isso consulta-se o fontconfig
if isunix && ~ismac
    [~, fam] = system('fc-list : family');
    disponiveis = strtrim(strsplit(fam, {',', newline}));
else
    disponiveis = listfonts;
end
candidatas  = {'Times New Roman', 'Liberation Serif', 'Nimbus Roman', 'Arial', ...
    'Liberation Sans', 'DejaVu Sans'};
letra = '';
for k = 1:numel(candidatas)
    if any(strcmp(candidatas{k}, disponiveis))
        letra = candidatas{k};
        break
    end
end
if isempty(letra)
    warning('ieee_guarda:letra', 'Nenhuma letra com serifa encontrada em listfonts; usa a letra por omissao.')
    letra = get(groot, 'DefaultAxesFontName');
end
fprintf('ieee_guarda: letra %s\n', letra);

% Eixos: tamanho e letra uniformes, multiplicadores a 1 para que os
% rotulos tenham o mesmo tamanho que os valores dos eixos
for ax = findall(fig, 'Type', 'axes')'
    set(ax, 'FontName', letra, 'FontSize', TAM, ...
        'LabelFontSizeMultiplier', 1, 'TitleFontSizeMultiplier', 1, ...
        'LineWidth', 0.5, 'TickDir', 'in', 'Box', 'on', ...
        'GridLineStyle', '-', 'GridColor', [0 0 0], 'GridAlpha', 0.12, 'Layer', 'top');
end

% Sem interpretador TeX: no PDF vetorial o texto TeX sai muito mais pequeno do
% que o resto. Os simbolos (theta, alpha, omega, +-, subscritos) estao escritos
% diretamente em Unicode nas figuras.
set(findall(fig, '-property', 'Interpreter'), 'Interpreter', 'none');
set(findall(fig, 'Type', 'axes'), 'TickLabelInterpreter', 'none');

% Anotacoes e legendas
set(findall(fig, 'Type', 'text'),   'FontName', letra, 'FontSize', TAM);
set(findall(fig, 'Type', 'legend'), 'FontName', letra, 'FontSize', TAM, ...
    'Box', 'off');

% Exportar: PDF vetorial (tamanho exato da figura) e PNG de 600 dpi.
% O tamanho fisico e reposto antes de cada exportacao, porque o MATLAB pode
% te-lo alterado (janela acoplada, exportacao anterior).
dim = get(fig, 'UserData');
pasta = fullfile('..', 'report', 'Figs');
if ~exist(pasta, 'dir'), mkdir(pasta); end

repor_tamanho(fig, dim)
exportgraphics(fig, fullfile(pasta, [nome '.pdf']), ...
    'ContentType', 'vector', 'Padding', 'figure');
repor_tamanho(fig, dim)
exportgraphics(fig, fullfile(pasta, [nome '.png']), ...
    'Resolution', 600, 'Padding', 'figure');

% Confirmar que o PNG tem o tamanho previsto (600 dpi) e avisar se nao tiver
info = imfinfo(fullfile(pasta, [nome '.png']));
esperado = round(dim*600);
if any(abs([info.Width info.Height] - esperado) > 4)
    warning('ieee_guarda:tamanho', '%s: exportada com %dx%d px, esperado %dx%d px.', ...
        nome, info.Width, info.Height, esperado(1), esperado(2));
end
end

function repor_tamanho(fig, dim)
% Repoe a largura e a altura da figura (polegadas) e avisa se o MATLAB nao as aceitar
set(fig, 'Units', 'inches');
pos = get(fig, 'Position');
set(fig, 'Position', [pos(1:2) dim], 'PaperUnits', 'inches', ...
    'PaperSize', dim, 'PaperPosition', [0 0 dim]);
drawnow
pos = get(fig, 'Position');
if any(abs(pos(3:4) - dim) > 0.01)
    warning('ieee_guarda:tamanho', 'A figura tem %.2fx%.2f in, esperado %.2fx%.2f in.', ...
        pos(3), pos(4), dim(1), dim(2));
end
end
