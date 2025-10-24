create or replace function criar_pagamento_automatico()
returns trigger as $$
begin
    insert into pagamentos (pedido_id, status, criado_em, valor)
    values (new.id, 'aberto', now(), new.total);
    return new;
end;
$$ language plpgsql;