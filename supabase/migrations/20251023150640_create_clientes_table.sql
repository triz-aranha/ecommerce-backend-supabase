-- Cria a tabela clientes
create table if not exists clientes (
    id bigserial primary key,
    nome text not null,
    email text unique not null,
    telefone text,
    criado_em timestamptz default now()
);
