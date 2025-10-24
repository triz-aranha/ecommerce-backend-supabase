CREATE VIEW produtos_mais_vendidos_quantidade AS
SELECT
    pr.id AS produto_id,
    pr.nome AS produto_nome,
    SUM(ip.quantidade) AS total_vendido
FROM itens_pedido ip
JOIN produtos pr ON ip.produto_id = pr.id
GROUP BY pr.id, pr.nome
ORDER BY total_vendido DESC;