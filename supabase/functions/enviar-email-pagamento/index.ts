import { serve } from "https://deno.land/x/sift@0.5.0/mod.ts";
import { createClient } from "https://cdn.jsdelivr.net/npm/@supabase/supabase-js/+esm";

const supabase = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
);

const RESEND_API_KEY = Deno.env.get("RESEND_API_KEY")!;

serve(async (req) => {
  const { pedidoId } = await req.json();
  if (!pedidoId) return new Response("pedidoId não informado", { status: 400 });

  const { data: pedido } = await supabase.from("pedidos").select("cliente_id").eq("id", pedidoId).single();
  if (!pedido) return new Response("Pedido não encontrado", { status: 404 });

  const { data: cliente } = await supabase.from("clientes").select("nome,email").eq("id", pedido.cliente_id).single();
  if (!cliente) return new Response("Cliente não encontrado", { status: 404 });

  await fetch("https://api.resend.com/emails", {
    method: "POST",
    headers: {
      "Authorization": `Bearer ${RESEND_API_KEY}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      from: "suporte@seusite.com",
      to: cliente.email,
      subject: `Pedido #${pedidoId} confirmado!`,
      html: `<h1>Olá ${cliente.nome}!</h1><p>Seu pedido #${pedidoId} foi confirmado e pago com sucesso.</p>`
    }),
  });

  return new Response(JSON.stringify({ status: "ok" }), { status: 200 });
});
