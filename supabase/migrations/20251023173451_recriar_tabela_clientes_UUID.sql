DROP TABLE IF EXISTS clientes;

CREATE TABLE clientes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    senha TEXT NOT NULL,
    criado_em TIMESTAMP DEFAULT now()
);

-- Ativar RLS
ALTER TABLE clientes ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "cliente_so_ve_seus_dados"
ON clientes
FOR SELECT
USING (auth.uid() = id);

CREATE POLICY "cliente_pode_criar"
ON clientes
FOR INSERT
WITH CHECK (auth.uid() = id);