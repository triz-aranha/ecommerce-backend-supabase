# E-commerce Backend (Supabase)

Backend de e-commerce desenvolvido com Supabase, usando PostgreSQL para o banco de dados e Edge Functions (Deno) para processamento serverless.

## ✅ Checklist de Implementação

### 🧩 1. Estrutura do Banco de Dados

#### ✅ Tabela `clientes`
- **Migration**: `20251023173451_recriar_tabela_clientes_UUID.sql`
- **Campos implementados**:
  - `id` (UUID, primary key)
  - `nome` (text, not null)
  - `email` (text, unique, not null)
  - `senha` (text, not null)
  - `criado_em` (timestamp, default now())

#### ✅ Tabela `produtos`
- **Migration**: `20251023164204_create_produtos_table.sql`
- **Campos implementados**:
  - `id` (bigserial, primary key)
  - `nome` (text, not null)
  - `descricao` (text)
  - `preco` (numeric(10,2), not null)
  - `estoque` (int, default 0)
  - `criado_em` (timestamptz, default now())

#### ✅ Tabela `pedidos`
- **Migrations**: 
  - Base: `20251023164354_create_pedidos_table.sql`
  - Cliente ID: `20251023171246_policy.sql`
  - Status: `20251023203529_add_status_to_pedidos.sql`
- **Campos implementados**:
  - `id` (bigserial, primary key)
  - `cliente_id` (UUID, references clientes)
  - `status` (text, default 'aberto')
  - `total` (numeric(10,2))
  - `criado_em` (timestamptz, default now())

#### ✅ Tabela `itens_pedido`
- **Migration**: `20251023171943_create_itens_pedido_table.sql`
- **Campos implementados**:
  - `id` (serial, primary key)
  - `pedido_id` (integer, references pedidos)
  - `produto_id` (integer, references produtos)
  - `quantidade` (integer, not null)
  - `preco` (numeric(10,2), not null)

#### ✅ Tabela `pagamentos`
- **Migration**: `20251024141138_create_pagamentos_table.sql`
- **Campos implementados**:
  - `id` (bigserial, primary key)
  - `pedido_id` (bigint, references pedidos)
  - `valor` (numeric(10,2), not null)
  - `status` (text, default 'aprovado')
  - `criado_em` (timestamptz, default now())

### 🔐 2. Row Level Security (RLS)

#### ✅ Ativação de RLS
- **Migration**: `20251023165740_rls.sql`
- **Tabelas com RLS ativo**: clientes, produtos, pedidos

#### ✅ Policies Implementadas
- **Clientes**:
  ```sql
  CREATE POLICY "cliente_so_ve_seus_dados"
  ON clientes FOR SELECT
  USING (auth.uid() = id);
  ```

- **Pedidos**:
  ```sql
  CREATE POLICY "cliente_so_ve_seus_pedidos"
  ON pedidos FOR SELECT
  USING (cliente_id = auth.uid());
  ```

- **Itens Pedido**:
  ```sql
  CREATE POLICY "cliente_so_ve_itens_dos_seus_pedidos"
  ON itens_pedido FOR SELECT
  USING (EXISTS (
      SELECT 1 FROM pedidos p
      WHERE p.id = itens_pedido.pedido_id
      AND p.cliente_id = auth.uid()
  ));
  ```

### ⚙️ 3. Funções e Triggers

#### ✅ Cálculo de Total do Pedido
- **Migration**: `20251023191149_calcula_total_pedido.sql`
- **Função**: `atualizar_total_pedido()`
- **Trigger**: `trigger_atualizar_total` (AFTER INSERT/UPDATE/DELETE ON itens_pedido)
- **Usa COALESCE**: Sim, `COALESCE(SUM(preco), 0)`

#### ✅ Atualização de Status do Pedido
- **Migration**: `20251024173159_atualiza_status_pedido.sql`
- **Função**: `atualiza_status_pedido()`
- **Trigger**: `trigger_pagamento_aprovado` (when new.status = 'aprovado')

#### ✅ Criação Automática de Pagamento
- **Migration**: `20251024160305_total_pedido_pagamento.sql`
- **Função**: `criar_pagamento_com_valor()`
- **Trigger**: `trigger_criar_pagamento_com_valor` (after insert on pedidos)

### 🌐 Edge Functions (Deno)

#### ✅ Função `enviar-email-pagamento`
- **Localização**: `supabase/functions/enviar-email-pagamento/index.ts`
- **Trigger**: `20251024191039_trigger_envia_email.sql`
- **Variáveis necessárias**:
  - `RESEND_API_KEY`
  - `SUPABASE_URL`
  - `SUPABASE_SERVICE_ROLE_KEY`

## 🚀 Como Executar

### Pré-requisitos
- Node.js
- Supabase CLI
- Deno (para Edge Functions)

### Comandos Principais

1. **Iniciar Supabase localmente**:
   ```bash
   npx supabase start
   ```

2. **Aplicar migrations**:
   ```bash
   npx supabase db push
   ```

3. **Executar Edge Function localmente**:
   ```bash
   npx supabase functions serve enviar-email-pagamento
   ```

4. **Testar envio de email**:
   ```bash
   curl -X POST "http://localhost:54321/functions/v1/enviar-email-pagamento" \
        -H "Content-Type: application/json" \
        -d '{"pedidoId": 123}'
   ```

## 📝 Itens Pendentes do Checklist

1. **Views**:
   - [ ] Criar view `pedidos_detalhados` com:
     ```sql
     CREATE VIEW pedidos_detalhados AS
     SELECT
       p.id AS pedido_id,
       c.nome AS cliente,
       pr.nome AS produto,
       i.quantidade,
       i.preco_unitario,
       (i.quantidade * i.preco_unitario) AS subtotal,
       p.total,
       p.status,
       pg.status AS status_pagamento
     FROM pedidos p
     JOIN clientes c ON p.cliente_id = c.id
     JOIN itens_pedido i ON i.pedido_id = p.id
     JOIN produtos pr ON pr.id = i.produto_id
     LEFT JOIN pagamentos pg ON pg.pedido_id = p.id;
     ```

2. **Edge Functions**:
   - [ ] Implementar `export_pedidos_csv`

3. **Performance**:
   - [ ] Adicionar índices em chaves estrangeiras:
     - `cliente_id` em `pedidos`
     - `pedido_id` em `itens_pedido`
     - `produto_id` em `itens_pedido`

4. **Triggers**:
   - [ ] Sincronizar `pagamentos.valor` com mudanças em `pedidos.total`

## 📚 Documentação Adicional

Para mais detalhes sobre o desenvolvimento e decisões técnicas, consulte:
- `JOURNAL.md`: Histórico de desenvolvimento e decisões
- `supabase/config.toml`: Configurações do projeto