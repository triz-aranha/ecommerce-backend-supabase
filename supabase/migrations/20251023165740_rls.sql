-- Cria as Politicas de RLS para a tabela clientes
alter table clientes enable row level security; 

-- Cria as políticas de RLS para a tabela produtos
alter table produtos enable row level security;         

-- Cria as políticas de RLS para a tabela pedidos
alter table pedidos enable row level security;