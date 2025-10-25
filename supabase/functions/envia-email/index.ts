import { serve } from "https://deno.land/std@0.203.0/http/server.ts";
const RESEND_API_KEY = Deno.env.get("RESEND_API_KEY");
const FROM_EMAIL = "Suporte <suporte@trizaranha.com.br>";
const SUPABASE_URL = Deno.env.get("SUPABASE_URL");
const SUPABASE_SERVICE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
serve(async (req)=>{
  try {
    const body = await req.json();
    const { event, record, old_record } = body;
    if (record.status === "pago") {
      console.log("chegou");
      const clienteId = record.cliente_id;
      const response = await fetch(`${SUPABASE_URL}/rest/v1/clientes?id=eq.${clienteId}`, {
        headers: {
          "apikey": SUPABASE_SERVICE_KEY,
          "Authorization": `Bearer ${SUPABASE_SERVICE_KEY}`
        }
      });
      const clientes = await response.json();
      const cliente = clientes[0];
      if (!cliente || !cliente.email) {
        console.error("Cliente não encontrado ou sem email.", clientes);
        return new Response("Cliente não encontrado", {
          status: 404
        });
      }
      if (!RESEND_API_KEY) {
        console.error("RESEND_API_KEY não está definida!");
        return new Response("Chave do Resend ausente", {
          status: 500
        });
      }
      const emailData = {
        from: FROM_EMAIL,
        to: cliente.email,
        subject: "Pagamento aprovado!",
        html: `
          <h2>Olá, ${cliente.nome || "cliente"}!</h2>
          <p>Seu pagamento do pedido #${record.id} foi aprovado. ✅</p>
          <p>Obrigado pela confiança!</p>
        `
      };
      const resendRes = await fetch("https://api.resend.com/emails", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Authorization": `Bearer ${RESEND_API_KEY}`
        },
        body: JSON.stringify(emailData)
      });
      const text = await resendRes.text();
      console.log("Resposta Resend:", resendRes.status, text);
      if (!resendRes.ok) {
        return new Response("Erro ao enviar email", {
          status: 500
        });
      }
      return new Response("Email enviado com sucesso!", {
        status: 200
      });
    }
    return new Response("Nada a fazer", {
      status: 200
    });
  } catch (err) {
    console.error("Erro geral:", err);
    return new Response("Erro interno", {
      status: 500
    });
  }
});
