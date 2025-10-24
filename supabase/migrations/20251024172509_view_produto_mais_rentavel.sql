CREATE VIEW produto_mais_rentavel AS
SELECT
    pr.id AS produto_id,
    pr.nome AS produto_nome,
    SUM(ip.quantidade) AS total_vendido,
    SUM(ip.quantidade * pr.preco) AS receita_total
FROM itens_pedido ip
JOIN produtos pr ON ip.produto_id = pr.id
JOIN pedidos p ON ip.pedido_id = p.id
WHERE p.status = 'aprovado'
GROUP BY pr.id, pr.nome
ORDER BY total_vendido DESC
LIMIT 1;
