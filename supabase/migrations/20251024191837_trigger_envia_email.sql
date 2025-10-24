create or replace function envia_email()
returns trigger as $$
begin
  -- Se o status mudou para "pago"
  if new.status = 'pago' and old.status is distinct from new.status then
    -- Chama a Edge Function via HTTP
    perform
    net.http_post(
            url := 'https://<seu-projeto>.functions.supabase.co/enviar_email_pagamento',
            headers := '{"Content-Type": "application/json"}',
            body := json_build_object('pedidoId', new.id)::text
        );
  end if;
  return new;
end;
$$ language plpgsql;

create or replace trigger trigger_envia_email
after update on pedidos
for each row
execute function envia_email();
