// Query all academic_tasks records that are not archived
query academic_tasks verb=GET {
  api_group = "Tasks"

  input {
  }

  stack {
    db.query academic_tasks {
      where = $db.academic_tasks.status != "arquivada" && $db.academic_tasks.status != "archived"
      return = {type: "list"}
    } as $model
  }

  response = $model
}