create trigger trigger_pagamento_aprovado
after update on pagamentos
for each row
when (new.status = 'aprovado')
execute function atualiza_status_pedido();
