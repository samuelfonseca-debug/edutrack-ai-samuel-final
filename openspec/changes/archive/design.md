# Design técnico: modelo de dados e relacionamentos para disciplinas

## Visão geral
Este documento descreve o design técnico do modelo de dados para a entidade `subject` (disciplina), incluindo tabelas, colunas, relacionamentos e regras de integridade. O objetivo é suportar controle de propriedade por usuário,
acesso baseado em conta e auditoria de operações sem implementar código.

## Tabelas envolvidas

### 1. `subject`
A tabela principal para representar disciplinas acadêmicas.

Colunas principais:
- `id`: chave primária única.
- `created_at`: timestamp de criação do registro.
- `updated_at`: timestamp de última atualização.
- `user_id`: chave estrangeira para o usuário proprietário.
- `account_id`: chave estrangeira para a conta associada ao usuário.
- `nome`: nome da disciplina.
- `codigo`: código da disciplina.
- `descricao`: descrição opcional da disciplina.
- `creditos`: número de créditos ou peso acadêmico.
- `semestre`: semestre associado à disciplina.
- `ativo`: indicador booleano para exclusão lógica.

Regras de integridade:
- `user_id` é obrigatório e referencia `user.id`.
- `account_id` é obrigatório e referencia `account.id`.
- `nome` e `codigo` são obrigatórios para garantir identificação mínima.
- `ativo` controla exclusão lógica; registros desativados não são removidos fisicamente.

### 2. `user`
Tabela de usuários do sistema existente.

Papel no design:
- cada `subject` pertence a exatamente um `user`.
- a propriedade de `subject` é usada para validação de acesso.

Relacionamentos:
- `subject.user_id -> user.id` (muitos para um)

### 3. `account`
Tabela de contas ou organizações.

Papel no design:
- cada disciplina é associada a uma conta por razões de organização e eventual controle multi-conta.
- permite segmentar disciplinas por conta quando usuários pertencem a diferentes organizações.

Relacionamentos:
- `subject.account_id -> account.id` (muitos para um)

### 4. `event_log`
Tabela de auditoria existente que registra ações do sistema.

Papel no design:
- capturar eventos relevantes de criação, atualização e exclusão lógica de disciplinas.
- permitir futuras integrações com notificações e workflows.

Relacionamentos opcionais:
- `event_log.subject_id -> subject.id` quando o modelo suportar referência direta de evento a disciplina.
- caso não exista coluna `subject_id`, basta registrar no payload do evento.

## Relacionamentos e cardinalidade

- `user 1 — N subject`
  - um usuário pode possuir múltiplas disciplinas.
  - cada disciplina está vinculada a um único usuário.

- `account 1 — N subject`
  - uma conta pode ter várias disciplinas associadas.
  - cada disciplina está vinculada a uma única conta.

- `subject 1 — N event_log` (opcional)
  - uma disciplina pode gerar vários eventos de auditoria.

## Restrições e validações

- Validação de propriedade: somente o usuário cujo `user_id` corresponde ao `subject.user_id` pode consultar, atualizar ou desativar o registro.
- Validação de conta: `subject.account_id` deve corresponder à conta do usuário autenticado sempre que houver contexto de conta ativa.
- Exclusão lógica: `ativo = false` indica disciplina inativa; buscas padrão devem filtrar apenas registros ativos.

## Índices recomendados

- índice em `subject.user_id` para consultas por proprietário.
- índice composto em `subject.account_id, subject.ativo` para operações de listagem por conta e status.
- índice em `subject.codigo` para buscas específicas por código de disciplina.

## Extensibilidade

O design permite futuras ampliações sem alterar a estrutura central:
- adicionar campos como `categoria`, `tipo`, `periodo` e `carga_horaria` em `subject`.
- incluir relacionamentos adicionais com `course`, `curriculum` ou `programa`.
- implementar logs de histórico de alterações com tabela separada de versões.

## Observações finais

Este design descreve a solução técnica e os relacionamentos necessários para suportar um modelo de disciplinas com vínculo de propriedade ao usuário e à conta, além de possibilitar auditoria de eventos. A implementação do banco de dados e das APIs ficará para a próxima etapa do fluxo incremental.
