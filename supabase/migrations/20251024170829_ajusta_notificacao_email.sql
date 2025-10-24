create or replace function notifica_pagamento_aprovado()
returns trigger as $$
declare
    cliente_email text;
begin
    if new.status = 'aprovado' then
        -- Busca o email do cliente via pedido
        select c.email
        into cliente_email
        from clientes c
        join pedidos p on p.cliente_id = c.id
        where p.id = new.pedido_id;

        -- Chama a Edge Function
        perform net.http_post(
            'https://ifqwmsdtzgbgmyrrnpuy.functions.supabase.co/notifica_pagamento_aprovado',
            '{"email":"' || cliente_email || '","pedido_id":' || new.pedido_id || ',"valor":' || new.valor || '}',
            'application/json'
        );
    end if;

    return new;
end;
$$ language plpgsql;
