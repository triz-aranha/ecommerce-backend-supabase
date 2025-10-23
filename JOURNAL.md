# Diário de Desenvolvimento

## 23-10
### Tarefas feitas
- Configurei Supabase CLI.
- Criei estrutura inicial do backend.

### Problemas/Impedimentos
- O supabase não executou seu comando da forma devida inicialmente, “Installing Supabase CLI as a global module is not supported.” 

### Decisões tomadas
- Utilizar o Supabase CLI facilita na hora de executar os commits no github, além de ser mais prático para manejar as tabelas.
- Devido ao erro de gmódulos globais, percebi que usando o npx ele roda normalmente. Vou usar `npx supabase` para rodar comandos do supabase.
- Estrutura inicial seguirá padrão gerado pelo próprio supabase.