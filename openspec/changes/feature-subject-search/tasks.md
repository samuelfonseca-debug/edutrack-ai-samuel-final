# Tarefas de implementação para search de subjects

## Tarefas

- [ ] Definir e documentar o novo endpoint `GET /subjects/search` em OpenSpec.
- [ ] Criar ou atualizar um helper Python que determina se um subject possui tarefas atrasadas a partir de `academic_tasks`.
- [ ] Implementar endpoint XanoScript que:
  - recebe `nome?` e `overdue_tasks?` como filtros
  - aplica autorização por usuário autenticado
  - usa a lógica Python para buscar subjects com tarefas atrasadas
  - combina os filtros em uma busca por nome OU overdue
- [ ] Adicionar testes de comportamento para garantir que o endpoint filtra apenas os subjects do usuário e respeita ambos os critérios.
- [ ] Atualizar a documentação de API / specs para incluir o novo endpoint de busca.
