-- Políticas itens_pedido

DROP POLICY IF EXISTS "cliente_so_ve_itens_dos_seus_pedidos" ON itens_pedido;

CREATE POLICY "cliente_so_ve_itens_dos_seus_pedidos"
ON itens_pedido
FOR SELECT
USING (
    EXISTS (
        SELECT 1 FROM pedidos p
        WHERE p.id = itens_pedido.pedido_id
        AND p.cliente_id = auth.uid()
    )
);
 DROP POLICY IF EXISTS "cliente_pode_inserir_item" ON itens_pedido; 
CREATE POLICY "cliente_pode_inserir_item"
ON itens_pedido
FOR INSERT
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM pedidos p
        WHERE p.id = itens_pedido.pedido_id
        AND p.cliente_id = auth.uid()
    )
);