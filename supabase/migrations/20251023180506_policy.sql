-- Políticas tabela pedidos
CREATE POLICY "cliente_so_ve_seus_pedidos"
ON pedidos
FOR SELECT
USING (cliente_id = auth.uid());

CREATE POLICY "cliente_pode_criar_pedido"
ON pedidos
FOR INSERT
WITH CHECK (cliente_id = auth.uid());

-- Políticas itens_pedido
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