-- criar função para notificar quando um pagamento for aprovado
create trigger pagamento_aprovado_trigger
after update on pagamentos
for each row
when (new.status = 'aprovado')
execute function notifica_pagamento_approvado();
