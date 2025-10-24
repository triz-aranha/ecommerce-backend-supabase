-- Tabela de pagamentos
CREATE TABLE pagamentos (
  id BIGSERIAL PRIMARY KEY,
  pedido_id BIGINT NOT NULL REFERENCES pedidos(id) ON DELETE CASCADE,
  valor NUMERIC(10,2) NOT NULL,
  status TEXT NOT NULL DEFAULT 'aprovado',
  criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);