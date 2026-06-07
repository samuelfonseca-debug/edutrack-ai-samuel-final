// Add academic_tasks record
query academic_tasks verb=POST {
  api_group = "Tasks"

  input {
    dblink {
      table = "academic_tasks"
    }
  }

  stack {
    db.add academic_tasks {
      enforce_hidden_fields = false
      data = {
        created_at : "now"
        title      : $input.title
        description: $input.description
        due_date   : $input.due_date
        status     : $input.status
        subject_id : $input.subject_id
      }
    } as $model
  }

  response = $model
}