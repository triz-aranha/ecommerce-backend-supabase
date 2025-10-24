create trigger trigger_criar_pagamento
after insert on pedidos
for each row
execute function criar_pagamento_automatico();