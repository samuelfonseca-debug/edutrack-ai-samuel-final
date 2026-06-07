// Update subjects record
query "subjects/{subjects_id}" verb=PUT {
  api_group = "Subjects"

  input {
    int subjects_id? filters=min:1
    dblink {
      table = "subjects"
    }
  }

  stack {
    db.edit subjects {
      field_name = "id"
      field_value = $input.subjects_id
      enforce_hidden_fields = false
      data = {}
    } as $model
  }

  response = $model
}