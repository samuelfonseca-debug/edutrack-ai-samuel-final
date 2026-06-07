// Deactivate a subject by marking it as inactive.
query "subjects/{subject_id}" verb=DELETE {
  api_group = "Subjects"
  auth = "user"

  input {
    int subject_id
  }

  stack {
    db.get subjects {
      field_name = "id"
      field_value = $input.subject_id
      output = ["id", "created_at", "updated_at", "user_id", "account_id", "nome", "codigo", "descricao", "creditos", "semestre", "ativo"]
    } as $subject

    precondition ($subject != null) {
      error_type = "notfound"
      error = "Subject not found."
    }

    precondition ($subject.user_id == $auth.id) {
      error_type = "accessdenied"
      error = "Access denied to delete this subject."
    }

    db.patch subjects {
      field_name = "id"
      field_value = $subject.id
      data = {ativo: false, updated_at: "now"}
      output = ["id", "created_at", "updated_at", "user_id", "account_id", "nome", "codigo", "descricao", "creditos", "semestre", "ativo"]
    } as $deleted_subject
  }

  response = $deleted_subject
}
