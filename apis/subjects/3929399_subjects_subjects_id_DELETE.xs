// Delete subjects record
query "subjects/{subjects_id}" verb=DELETE {
  api_group = "Subjects"

  input {
    int subjects_id? filters=min:1
  }

  stack {
    db.del subjects {
      field_name = "id"
      field_value = $input.subjects_id
    }
  }

  response = null
}