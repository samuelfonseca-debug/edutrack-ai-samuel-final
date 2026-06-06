# feature-notas-atividades Specification

## Purpose
Definir a estrutura técnica mínima para o recurso de lançamento de notas em atividades, com foco exclusivo no endpoint `POST /activity_grades` e no registro da nota pelo professor.

## ADDED Requirements

### Requirement: Estrutura da tabela activity_grades
O sistema SHALL armazenar os lançamentos de notas de atividades na tabela `activity_grades`.
#### Detalhes da tabela
- `id`: chave primária única
- `created_at`: timestamp do lançamento
- `activity_id`: referência à atividade avaliada
- `student_id`: referência ao aluno avaliado
- `grade`: valor da nota lançada
- `teacher_id`: referência ao professor autenticado que lançou a nota
- `comment?`: campo opcional de texto com observação sobre o lançamento

### Requirement: Endpoint POST /activity_grades
O sistema SHALL expor o endpoint `POST /activity_grades` para registrar uma nota de atividade.
#### Payload esperado
- `activity_id` (integer, obrigatório): identifica a atividade que está sendo avaliada
- `student_id` (integer, obrigatório): identifica o aluno que recebeu a nota
- `grade` (number, obrigatório): valor da nota, conforme regras de domínio
- `comment` (string, opcional): observações sobre o lançamento

#### Validações de campos
- `activity_id` MUST ser fornecido e existir no domínio de atividades
- `student_id` MUST ser fornecido e existir como aluno válido
- `grade` MUST ser fornecido e estar dentro dos limites aceitos pelo sistema
- `comment`, quando presente, SHOULD ser uma string de tamanho razoável

#### Validação de perfil de professor
- O endpoint SHALL aceitar apenas requisições de usuários autenticados com perfil de professor
- O campo `teacher_id` deverá ser preenchido automaticamente a partir do usuário autenticado
- Usuários sem perfil de professor SHALL receber uma resposta de acesso negado

### Requirement: Comportamento e erros
- O endpoint SHALL criar um registro em `activity_grades` quando todos os dados forem válidos
- O endpoint SHALL retornar erro de validação para payload incompleto ou inválido
- O endpoint SHALL retornar erro de autorização quando o usuário não for professor
- O endpoint SHALL não incluir lógica de consulta ou listagem de notas neste escopo

#### Cenários de teste de comportamento

#### Scenario: Professor lança nota com sucesso
- **WHEN** um usuário autenticado com perfil de professor envia `POST /activity_grades` com `activity_id`, `student_id` e `grade` válidos
- **THEN** o sistema valida os campos e cria um registro em `activity_grades`
- **THEN** a resposta contém o registro criado, incluindo `id`, `created_at` e `teacher_id`

#### Scenario: Falha quando usuário não é professor
- **WHEN** um usuário autenticado sem perfil de professor tenta registrar nota em `POST /activity_grades`
- **THEN** o sistema retorna um erro de autorização (por exemplo, 403 Forbidden)
- **THEN** nenhum registro é criado em `activity_grades`

#### Scenario: Falha por payload incompleto ou inválido
- **WHEN** o professor envia `POST /activity_grades` sem `activity_id`, `student_id` ou `grade`
- **THEN** o sistema retorna um erro de validação (por exemplo, 400 Bad Request)
- **THEN** a resposta descreve os campos faltantes ou inválidos

#### Scenario: Falha por referência de entidade inexistente
- **WHEN** o professor envia `POST /activity_grades` com `activity_id` ou `student_id` que não existem
- **THEN** o sistema retorna um erro de validação ou recurso não encontrado
- **THEN** nenhum registro é criado em `activity_grades`
