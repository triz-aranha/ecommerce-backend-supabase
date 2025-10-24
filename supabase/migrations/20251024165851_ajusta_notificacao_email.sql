create or replace function notifica_pagamento_aprovado()
returns trigger as $$
declare
    cliente_email text;
begin
    if new.status = 'aprovado' then
        -- Busca o email do cliente
        select email into cliente_email
        from clientes
        where id = new.cliente_id;

        -- Chama a Edge Function passando o email correto
        perform net.http_post(
            'https://ifqwmsdtzgbgmyrrnpuy.functions.supabase.co/notifica_pagamento_aprovado',
            '{"email":"' || cliente_email || '","pedido_id":' || new.id || ',"valor":' || new.total || '}',
            'application/json'
        );
    end if;

    return new;
end;
$$ language plpgsql;
