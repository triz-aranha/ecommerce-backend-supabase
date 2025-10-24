CREATE VIEW produtos_mais_rentavel AS
SELECT
    pr.id AS produto_id,
    pr.nome AS produto_nome,
    SUM(ip.quantidade * ip.preco_unitario) AS receita_total
FROM itens_pedido ip
JOIN produtos pr ON ip.produto_id = pr.id
GROUP BY pr.id, pr.nome
ORDER BY receita_total DESC;
