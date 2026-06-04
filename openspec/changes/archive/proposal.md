# Proposta de artefato: Disciplinas acadêmicas com propriedade de usuário

## Objetivo
Criar um artefato de documentação que descreva a criação de uma base de dados para disciplinas (`subjects`) em que cada registro pertence a um usuário autenticado. Este modelo deve habilitar:
- gerenciamento pessoal de disciplinas pelos usuários
- controle de acesso baseado em propriedade
- suporte a automações futuras por meio de logs de eventos

## Escopo
O artefato deve cobrir:
1. modelo de dados para a tabela `subject`
2. relacionamentos com `user` e `account`
3. regras de acesso e propriedade
4. APIs previstas para CRUD incremental
5. justificativa para exclusão lógica e extendibilidade

## Proposta de modelo
### Tabela `subject`
- `id`: chave primária
- `created_at`: timestamp de criação
- `user_id`: referência ao usuário proprietário
- `account_id`: referência à conta do usuário
- `nome`: nome da disciplina
- `codigo`: código da disciplina
- `descricao`: descrição opcional
- `creditos`: número de créditos
- `semestre`: semestre associado
- `ativo`: indicador de remoção lógica

### Regras de propriedade
- cada disciplina pertence a um único usuário
- apenas o usuário proprietário pode consultar, editar ou marcar a disciplina como inativa
- o acesso aos endpoints deve validar `subject.user_id == $auth.id`

## APIs propostas
- `GET /subjects`: listar disciplinas ativas do usuário autenticado
- `POST /subjects`: criar disciplina para o usuário autenticado
- `GET /subjects/{id}`: recuperar disciplina por ID, validando propriedade
- `PATCH /subjects/{id}`: atualizar disciplina do usuário proprietário
- `DELETE /subjects/{id}`: marcar disciplina como inativa

## Automação e auditoria
- cada operação relevante deve gerar entrada em event log
- eventos esperados: `subject_created`, `subject_updated`, `subject_deleted`
- essa base permite integrações futuras com notificações, relatórios ou regras de workflow

## Observações para revisão
- este arquivo é uma proposta de design, sem implementação de código
- o próximo passo, após aprovação, será criar os artefatos incrementais de implementação
