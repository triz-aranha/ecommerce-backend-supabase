# Diário de Desenvolvimento

## 23-10
### Tarefas feitas
- Configurei Supabase CLI.
- Criei estrutura inicial do backend.

### Problemas/Impedimentos
- O supabase não executou seu comando da forma devida inicialmente, “Installing Supabase CLI as a global module is not supported.” 
- Ao fazer as policys, percebi que se manter a tabela pedidos como está, terei problemas em armanezar mais de um item por pedido, então criarei um outra tabela só para os itens do pedido.
- Erro ao criar policys devido ao tipo de ID, mudar para UUID na tabela clientes e ver se será suficiente.
- Foi o suficiente, entretanto tive que editar algumas policies.
- Houve um momento que ao executar as migrations, acabei movendo a migration para outra pasta temporariamente pois ela estava dando erro, impedindo que a migration mais recente, que solucionaria o erro, executasse. Vejo que resolveu o problema, mas que poderia ocasionar problema caso fosse replicar a construção do banco.

### Decisões tomadas
- Utilizar o Supabase CLI facilita na hora de executar os commits no github, além de ser mais prático para manejar as tabelas.
- Devido ao erro de gmódulos globais, percebi que usando o npx ele roda normalmente. Vou usar `npx supabase` para rodar comandos do supabase.
- Estrutura inicial seguirá padrão gerado pelo próprio supabase.
- Conexão com o banco usando npx supabase link --project-ref ifqwmsdtzgbgmyrrnpuy, configurando o token de acesso do tipo sbp_123312... no .env.
- Ao Criar as tabelas no migrations, coloquei o comando If no exists, para que crie uma tabela somente se ela já não existir.
- Criar tabelas na sequencia, para não ter erros devido as primary keys: clientes, produtos e pedidos. 
- Para as funções também utilizarei o migrations para implementá-las.

### Para criar tabelas:

- Gerar a migration com o comando: npx supabase migration new create_pedidos_table 
- Adicionar o sql no arquivo da migration
- Salvar e então executar o comando: npx supabase db push