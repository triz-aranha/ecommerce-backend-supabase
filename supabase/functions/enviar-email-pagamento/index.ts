import { serve } from "https://deno.land/std@0.177.0/http/server.ts";

serve(async (req) => {
  try {
    const { email, nome, pedido_id, valor } = await req.json();

    if (!email || !pedido_id || !valor) {
      return new Response(
        JSON.stringify({ error: "Dados incompletos" }),
        { status: 400 }
      );
    }

    const response = await fetch("https://api.resend.com/emails", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${Deno.env.get("RESEND_API_KEY")}`
      },
      body: JSON.stringify({
        from: "sua-loja@seudominio.com",
        to: email,
        subject: "Confirmação de Pagamento",
        html: `
          <p>Olá ${nome || "Cliente"},</p>
          <p>Seu pagamento do pedido #${pedido_id} no valor de R$${valor} foi aprovado!</p>
          <p>Obrigado pela sua compra.</p>
        `
      })
    });

    if (!response.ok) {
      const errorText = await response.text();
      throw new Error(errorText);
    }

    return new Response(
      JSON.stringify({ status: "Email enviado com sucesso!" }),
      { status: 200 }
    );

  } catch (err) {
    return new Response(
      JSON.stringify({ error: err.message }),
      { status: 500 }
    );
  }
});
