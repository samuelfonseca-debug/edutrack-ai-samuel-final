// Query all academic_tasks records
query academic_tasks verb=GET {
  api_group = "Tasks"

  input {
  }

  stack {
    db.query academic_tasks {
      return = {type: "list"}
    } as $model
  }

  response = $model
}