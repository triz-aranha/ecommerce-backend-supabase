-- Função para atualizar total do pedido
CREATE OR REPLACE FUNCTION atualizar_total_pedido()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE pedidos
    SET total = (
        SELECT COALESCE(SUM(subtotal), 0)
        FROM itens_pedido
        WHERE pedido_id = NEW.pedido_id
    )
    WHERE id = NEW.pedido_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para chamar a função ao alterar itens
CREATE TRIGGER trigger_atualizar_total
AFTER INSERT OR UPDATE OR DELETE ON itens_pedido
FOR EACH ROW
EXECUTE FUNCTION atualizar_total_pedido();