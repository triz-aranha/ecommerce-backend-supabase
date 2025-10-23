-- Cria a tabela pedidos
create table if not exists pedidos (
    id bigserial primary key,
    produto_id bigserial references produtos(id),
    quantidade int not null,
    total numeric(10,2) not null,
    criado_em timestamptz default now()
);