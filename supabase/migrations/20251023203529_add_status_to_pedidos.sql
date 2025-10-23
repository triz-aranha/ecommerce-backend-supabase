-- Adiciona coluna status à tabela pedidos
ALTER TABLE pedidos
ADD COLUMN status TEXT DEFAULT 'aberto' CHECK (status IN ('aberto', 'finalizado', 'pago', 'cancelado'));
