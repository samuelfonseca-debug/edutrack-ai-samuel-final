// Get a subject by ID only if it belongs to the authenticated user.
query "subjects/{subject_id}" verb=GET {
  api_group = "Subjects"
  auth = "user"

  input {
    int subject_id
  }

  stack {
    db.get user {
      field_name = "id"
      field_value = $auth.id
    } as $user

    precondition ($user.id == $auth.id) {
      error_type = "notfound"
      error = "Authenticated user not found."
    }

    db.get subject {
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
      error = "Access denied to this subject."
    }

    precondition ($subject.account_id == $user.account_id) {
      error_type = "accessdenied"
      error = "Access denied to this account's subject."
    }
  }

  response = $subject
  tags = ["xano:quick-start"]
}
