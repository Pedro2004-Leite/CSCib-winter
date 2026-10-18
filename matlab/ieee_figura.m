function fig = ieee_figura(largura, altura)
% IEEE_FIGURA  Cria uma figura com as dimensoes fisicas finais.
%   largura: 'coluna' (3.5 in, uma coluna IEEE), 'pagina' (largura do texto do
%            documento) ou um valor em polegadas.
%   altura:  altura em polegadas (maximo IEEE: 8.8 in).
% A figura entra no documento sem redimensionar (largura = largura do texto),
% por isso o texto fica ao tamanho com que foi desenhado (ver ieee_guarda).
% Se o template oficial tiver outra largura de texto, mudar o valor de 'pagina'.

if ischar(largura) || isstring(largura)
    switch char(largura)
        case 'coluna', largura = 3.5;
        case 'pagina', largura = 6.27;   % A4 com margens de 1 in; IEEE duas colunas: 7.16 in
        otherwise, error('largura deve ser ''coluna'', ''pagina'' ou um numero')
    end
end
% Figura invisivel: sem janela, o gestor de janelas nao a redimensiona (num
% gestor em mosaico as figuras visiveis ocupavam o ecra todo)
fig = figure('Visible', 'off', 'WindowStyle', 'normal', 'Units', 'inches', ...
    'Position', [1 1 largura altura], 'UserData', [largura altura], ...
    'PaperUnits', 'inches', 'PaperSize', [largura altura], ...
    'PaperPosition', [0 0 largura altura], 'Color', 'w');
end
