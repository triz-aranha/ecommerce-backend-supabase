CREATE OR REPLACE FUNCTION calcular_preco_itens()
RETURNS TRIGGER AS $$
BEGIN
  -- Pega o preço do produto da tabela produtos
  SELECT preco INTO NEW.preco
  FROM produtos
  WHERE id = NEW.produto_id;

  -- Multiplica pela quantidade
  NEW.preco := NEW.preco * NEW.quantidade;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2. Cria a trigger que chama a função antes de inserir ou atualizar
CREATE TRIGGER trigger_calcular_preco
BEFORE INSERT OR UPDATE ON itens_pedido
FOR EACH ROW
EXECUTE FUNCTION calcular_preco_itens();