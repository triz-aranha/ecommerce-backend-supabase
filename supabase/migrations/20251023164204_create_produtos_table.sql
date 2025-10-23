-- Cria a tabela produtos
create table if not exists produtos (
    id bigserial primary key,
    nome text not null,
    descricao text,
    preco numeric(10,2) not null,
    estoque int default 0,
    criado_em timestamptz default now()
);