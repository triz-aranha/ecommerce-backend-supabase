create or replace function atualiza_status_pedido()
returns trigger as $$
begin
    -- Verifica se o pagamento foi aprovado
    if new.status = 'aprovado' then
        -- Atualiza o status do pedido relacionado
        update pedidos
        set status = 'concluido'
        where id = new.pedido_id;
    end if;

    return new;
end;
$$ language plpgsql;