INSERT INTO clientes (id, nome, email, senha, criado_em) VALUES
  ('a1b2c3d4-e5f6-7890-1234-abcdef123456', 'Beatriz Aranha', 'bea@teste.com', 'senha123', NOW()),
  ('b2c3d4e5-f6a7-8901-2345-bcdef234567a', 'João Lima', 'joao@teste.com', 'senha123', NOW()),
  ('c3d4e5f6-a7b8-9012-3456-cdef345678ab', 'Maria Silva', 'maria@teste.com', 'senha123', NOW());

INSERT INTO produtos (nome, descricao, preco, estoque, criado_em) VALUES
  ('Shampoo Hidratante', 'Shampoo para cabelos secos e danificados', 39.90, 100, NOW()),
  ('Condicionador Suave', 'Condicionador nutritivo com óleo de argan', 42.50, 120, NOW()),
  ('Máscara Capilar', 'Máscara reparadora intensa', 59.00, 80, NOW()),
  ('Sabonete Natural', 'Sabonete artesanal de lavanda', 15.00, 200, NOW());

