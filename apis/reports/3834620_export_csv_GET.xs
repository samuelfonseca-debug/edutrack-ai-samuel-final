// Endpoint para exportar todos os dados do usuário em formato CSV
query "reports/export/csv" verb=GET {
  api_group = "Reports"
  auth = "user"

  stack {
    // 1. Buscar todas as disciplinas do usuário
    db.get_records subjects {
      query = [{field: "user_id", op: "=", value: $auth.id}]
    } as $all_subjects

    // 2. Buscar todas as tarefas do usuário
    db.get_records academic_tasks {
      query = [{field: "user_id", op: "=", value: $auth.id}]
    } as $all_tasks

    // 3. Processar e transformar em strings CSV usando o Helper Python
    function.run "reports/generate_csv" {
      input = {
        subjects: $all_subjects
        tasks: $all_tasks
      }
    } as $csv_data
  }

  // Retorna os dados estruturados prontos para download
  response = $csv_data
}