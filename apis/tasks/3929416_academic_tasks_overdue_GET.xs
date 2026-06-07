// List academic tasks that are past their due date and not completed
query "academic_tasks/overdue" verb=GET {
  api_group = "Tasks"
  auth = "user"

  stack {
    // 1. Validar o usuário autenticado
    db.get user {
      field_name = "id"
      field_value = $auth.id
    } as $user

    precondition ($user.id == $auth.id) {
      error_type = "notfound"
    }

    // 2. Buscar as tarefas não concluídas e não arquivadas do usuário
    db.get_records academic_tasks {
      query = [
        {field: "user_id", op: "=", value: $auth.id},
        {field: "status", op: "!=", value: "arquivada"},
        {field: "status", op: "!=", value: "archived"}
      ]
    } as $all_tasks

    // 3. Helper Python para comparar com a data atual e filtrar as atrasadas
    function.run "tasks/filter_overdue_tasks" {
      input = {
        tasks: $all_tasks
      }
    } as $overdue_tasks
  }

  response = $overdue_tasks
}