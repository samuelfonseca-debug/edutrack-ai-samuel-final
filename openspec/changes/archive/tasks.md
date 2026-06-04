# Tarefas de implementação para disciplinas acadêmicas

## Objetivo
Definir os passos necessários para implementar o modelo de disciplinas (`subject`) com propriedade do usuário, controle de conta e auditoria de operações.

## Tarefas

1. [x] Definir o modelo de dados para `subject`
   - [x] criar a tabela `subject` com colunas: `id`, `created_at`, `updated_at`, `user_id`, `account_id`, `nome`, `codigo`, `descricao`, `creditos`, `semestre`, `ativo`
   - [x] aplicar restrições de integridade referencial para `user_id -> user.id` e `account_id -> account.id`
   - [x] adicionar índices em `user_id`, `account_id, ativo` e `codigo`

2. [x] Implementar exclusão lógica e status de ativo
   - [x] garantir que o campo `ativo` seja definido como verdadeiro por padrão
   - [x] atualizar as consultas para filtrar apenas registros ativos por padrão
   - [x] tratar `DELETE /subjects/{id}` como marcação do registro como inativo

3. [x] Criar APIs CRUD para `subject`
   - [x] `GET /subjects`: listar disciplinas ativas do usuário autenticado
   - [x] `POST /subjects`: criar disciplina vinculada ao usuário e conta autenticados
   - [x] `GET /subjects/{id}`: recuperar disciplina pelo ID com validação de propriedade
   - [x] `PATCH /subjects/{id}`: atualizar disciplina do usuário proprietário
   - [x] `DELETE /subjects/{id}`: desativar disciplina por exclusão lógica

4. [x] Validar acesso por propriedade e conta
   - [x] em cada endpoint, confirmar que `subject.user_id == auth.user_id`
   - [x] validar também que `subject.account_id` corresponde à conta do usuário autenticado quando aplicável
   - [x] impedir qualquer ação sobre disciplinas pertencentes a outros usuários

5. [x] Registrar eventos de auditoria
   - [x] gerar entradas em `event_log` para eventos: `subject_created`, `subject_updated`, `subject_deleted`
   - [x] incluir referência ao `subject.id` e dados relevantes no payload do evento
   - [x] garantir rastreabilidade dos fluxos de criação, atualização e exclusão lógica

6. [x] Criar testes de comportamento
   - [x] testar criação de disciplina para o usuário autenticado
   - [x] testar listagem que retorna apenas disciplinas ativas do usuário
   - [x] testar recuperação, atualização e exclusão lógica apenas pelo proprietário
   - [x] testar que outra conta ou usuário não consegue acessar/alterar a disciplina

## Observação
Estas tarefas seguem o design técnico definido em `design.md` e suportam a implementação incremental do recurso sem modificar decisões de escopo.

## Status
A implementação do modelo de dados, APIs, controle de propriedade, auditoria e testes de comportamento foi concluída.
