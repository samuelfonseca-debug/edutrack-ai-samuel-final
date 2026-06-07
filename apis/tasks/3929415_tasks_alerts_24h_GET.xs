// Busca tarefas do usuário que vencem nas próximas 24 horas
query "tasks/alerts/24h" verb=GET {
  api_group = "Tasks"
  auth = "user"

  stack {
    // 1. Buscar o usuário autenticado
    db.get user {
      field_name = "id"
      field_value = $auth.id
    } as $user

    precondition ($user.id == $auth.id) {
      error_type = "notfound"
    }

    // 2. Buscar todas as tarefas pendentes do usuário
    db.get_records academic_tasks {
      query = [
        {field: "user_id", op: "=", value: $auth.id},
        {field: "status", op: "!=", value: "arquivada"},
        {field: "status", op: "!=", value: "archived"}
      ]
    } as $pending_tasks

    // 3. Filtrar usando o Helper Python para achar o que vence nas próximas 24h
    function.run "tasks/filter_24h_reminders" {
      input = {
        tasks: $pending_tasks
      }
    } as $urgent_tasks
  }

  response = $urgent_tasks
}