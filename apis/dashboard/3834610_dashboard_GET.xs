// Retorna as métricas e visão geral para a tela inicial do Dashboard
query "dashboard" verb=GET {
  api_group = "Dashboard"
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

    // 2. Buscar todas as disciplinas do usuário (para contar as ativas)
    db.get_records subjects {
      query = [{field: "user_id", op: "=", value: $auth.id}]
    } as $all_subjects

    // 3. Buscar todas as tarefas do usuário
    db.get_records academic_tasks {
      query = [{field: "user_id", op: "=", value: $auth.id}]
    } as $all_tasks

    // 4. Processar os dados (Lógica no Helper Python)
    function.run "dashboard/calculate_metrics" {
      input = {
        subjects: $all_subjects
        tasks: $all_tasks
      }
    } as $metrics
  }

  response = $metrics
}