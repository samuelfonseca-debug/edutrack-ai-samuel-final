# Tarefas para feature-notas-atividades

## Objetivo
Definir os passos necessários para implementar apenas o fluxo de lançamento de notas de atividade pelo professor.

## Tarefas

1. [ ] Criar tabela `activity_grades`
   - [ ] incluir campos mínimos: `id`, `created_at`, `activity_id`, `student_id`, `grade`, `teacher_id`, `comment?`
   - [ ] garantir que `activity_id` e `student_id` referenciem entidades existentes no domínio
   - [ ] armazenar `teacher_id` como referência ao professor autenticado que lançou a nota

2. [ ] Criar endpoint `POST /activity_grades`
   - [ ] aceitar payload com `activity_id`, `student_id`, `grade` e campo opcional `comment`
   - [ ] validar que o usuário autenticado é professor
   - [ ] registrar o lançamento de nota na tabela `activity_grades`
   - [ ] retornar o registro criado ou erro de validação claro

3. [ ] Implementar autorização e validação de dados de domínio
   - [ ] impedir lançamento de nota por usuário que não seja professor
   - [ ] validar existência e compatibilidade de `activity_id` e `student_id`
   - [ ] validar formato de nota e limites permitidos antes de gravar

4. [ ] Documentar o escopo restrito
   - [ ] deixar explícito que esta funcionalidade cobre apenas o lançamento de notas
   - [ ] não incluir endpoints de listagem ou consulta de notas no escopo atual
