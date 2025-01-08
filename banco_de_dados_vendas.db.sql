/*
SQL em análise de dados, aplicação de filtros nas consultas, análise de séries temporais e criação de relatórios. 
*/

-- Consultas iniciais: Visualização das tabelas
SELECT * FROM categorias;
SELECT * FROM clientes;
SELECT * FROM fornecedores;
SELECT * FROM itens_venda;
SELECT * FROM marcas;
SELECT * FROM produtos;
SELECT * FROM vendas;

-- Contagem geral de registros em cada tabela
SELECT COUNT(*) AS Total_Clientes FROM clientes;
SELECT COUNT(*) AS Total_Fornecedores FROM fornecedores;
SELECT COUNT(*) AS Total_Marcas FROM marcas;
SELECT COUNT(*) AS Total_Produtos FROM produtos;
SELECT COUNT(*) AS Total_Vendas FROM vendas;

-- Contagem unificada das tabelas
SELECT COUNT(*) AS Qtd, 'Categorias' AS Tabela FROM categorias
UNION ALL
SELECT COUNT(*) AS Qtd, 'Clientes' AS Tabela FROM clientes
UNION ALL
SELECT COUNT(*) AS Qtd, 'Fornecedores' AS Tabela FROM fornecedores
UNION ALL
SELECT COUNT(*) AS Qtd, 'ItensVenda' AS Tabela FROM itens_venda
UNION ALL
SELECT COUNT(*) AS Qtd, 'Marcas' AS Tabela FROM marcas
UNION ALL
SELECT COUNT(*) AS Qtd, 'Produtos' AS Tabela FROM produtos
UNION ALL
SELECT COUNT(*) AS Qtd, 'Vendas' AS Tabela FROM vendas;

-- Consultar os 5 primeiros registros da tabela de vendas
SELECT * FROM vendas LIMIT 5;

-- Análise de vendas por ano
SELECT DISTINCT strftime('%Y', data_venda) AS Ano
FROM vendas
ORDER BY Ano;

SELECT strftime('%Y', data_venda) AS Ano, COUNT(id_venda) AS Total_Vendas
FROM vendas
GROUP BY Ano
ORDER BY Ano;

-- Análise de vendas por ano e mês
SELECT strftime('%Y', data_venda) AS Ano, strftime('%m', data_venda) AS Mes, COUNT(id_venda) AS Total_Vendas
FROM vendas
GROUP BY Ano, Mes
ORDER BY Ano, Mes;

-- Filtrando meses específicos (Janeiro, Novembro, Dezembro)
SELECT strftime('%Y', data_venda) AS Ano, strftime('%m', data_venda) AS Mes, COUNT(id_venda) AS Total_Vendas
FROM vendas
WHERE Mes IN ('01', '11', '12')
GROUP BY Ano, Mes
ORDER BY Ano, Mes;

-- Papel dos fornecedores na Black Friday
SELECT strftime('%Y/%m', v.data_venda) AS 'Ano/Mes', f.nome AS Nome_Fornecedor, COUNT(iv.produto_id) AS Qtd_Vendas
FROM itens_venda iv
JOIN vendas v ON v.id_venda = iv.venda_id
JOIN produtos p ON p.id_produto = iv.produto_id
JOIN fornecedores f ON f.id_fornecedor = p.fornecedor_id
WHERE strftime('%m', v.data_venda) = '11'
GROUP BY Nome_Fornecedor, 'Ano/Mes'
ORDER BY 'Ano/Mes', Qtd_Vendas;

-- Análise de categorias de produtos na Black Friday
SELECT strftime('%Y', v.data_venda) AS Ano, c.nome_categoria AS Nome_Categoria, COUNT(iv.produto_id) AS Qtd_Vendas
FROM itens_venda iv
JOIN vendas v ON v.id_venda = iv.venda_id
JOIN produtos p ON p.id_produto = iv.produto_id
JOIN categorias c ON c.id_categoria = p.categoria_id
WHERE strftime('%m', v.data_venda) = '11'
GROUP BY Nome_Categoria, Ano
ORDER BY Ano, Qtd_Vendas DESC;

-- Porcentagem de vendas por categorias
SELECT c.nome_categoria AS Nome_Categoria, COUNT(iv.produto_id) AS Qtd_Vendas,
       ROUND(100.0 * COUNT(iv.produto_id) / (SELECT COUNT(*) FROM itens_venda), 2) || '%' AS Porcentagem
FROM itens_venda iv
JOIN produtos p ON p.id_produto = iv.produto_id
JOIN categorias c ON c.id_categoria = p.categoria_id
GROUP BY Nome_Categoria
ORDER BY Qtd_Vendas DESC;

-- Quadro geral: Vendas por mês e ano
SELECT strftime('%m', data_venda) AS Mes, strftime('%Y', data_venda) AS Ano, COUNT(*) AS Qtd_Vendas
FROM vendas
GROUP BY Mes, Ano
ORDER BY Mes, Ano;

-- Comparação de vendas na Black Friday (2022 vs média anterior)
WITH Media_Vendas_Anteriores AS (
    SELECT AVG(Qtd_Vendas) AS Media_Qtd_Vendas
    FROM (
        SELECT COUNT(*) AS Qtd_Vendas, strftime('%Y', v.data_venda) AS Ano
        FROM vendas v
        WHERE strftime('%m', v.data_venda) = '11' AND strftime('%Y', data_venda) != '2022'
        GROUP BY Ano
    )
),
Vendas_Atual AS (
    SELECT COUNT(*) AS Qtd_Vendas_Atual
    FROM vendas
    WHERE strftime('%m', data_venda) = '11' AND strftime('%Y', data_venda) = '2022'
)
SELECT mva.Media_Qtd_Vendas,
       va.Qtd_Vendas_Atual,
       ROUND((va.Qtd_Vendas_Atual - mva.Media_Qtd_Vendas) / mva.Media_Qtd_Vendas * 100, 2) || '%' AS Variacao
FROM Vendas_Atual va, Media_Vendas_Anteriores mva;
