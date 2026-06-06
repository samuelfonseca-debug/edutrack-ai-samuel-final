# feature-notas-atividades Specification

## Why
Permitir que um professor lance notas para um aluno em uma atividade específica, mantendo o escopo restrito apenas ao registro da nota. Esta mudança deve apoiar o fluxo de avaliação sem incluir consultas ou listagens de notas.

## What Changes
- Adicionar a tabela `activity_grades` para armazenar lançamentos de nota por atividade, aluno e professor.
- Criar o endpoint `POST /activity_grades` para que o professor registre uma nova nota.
- Validar que apenas usuários com perfil de professor possam lançar notas.
- Validar os dados obrigatórios do lançamento: `activity_id`, `student_id` e `grade`.
- Garantir integridade mínima com as entidades de atividade e aluno existentes.
- Retornar o registro criado ou erro de validação apropriado.

## Impact
- Habilita o lançamento de notas em atividades específicas sem incluir APIs de consulta ou listagem de notas.
- Mantém o escopo estritamente no fluxo de criação de nota pelo professor.
- Cria uma base estruturada para futuras extensões, como relatórios de notas ou edição de lançamentos, sem exigir essas funcionalidades agora.
