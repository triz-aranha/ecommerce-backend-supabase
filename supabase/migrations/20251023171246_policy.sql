ALTER TABLE pedidos
ADD COLUMN cliente_id UUID REFERENCES clientes(id);


