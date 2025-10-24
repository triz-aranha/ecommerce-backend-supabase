create or replace function criar_pagamento_com_valor()
returns trigger as $$
begin
    -- Inserir na tabela pagamentos usando o total do pedido
    insert into pagamentos (pedido_id, valor, status, criado_em)
    values (new.id, new.total, 'aberto', now());
    
    return new;
end;
$$ language plpgsql;

create trigger trigger_criar_pagamento_com_valor
after insert on pedidos
for each row
execute function criar_pagamento_com_valor();