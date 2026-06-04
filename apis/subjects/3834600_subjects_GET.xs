// List active subjects for the authenticated user.
query "subjects" verb=GET {
  api_group = "Subjects"
  auth = "user"

  input {
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

    db.query subject {
      where = $db.subject.user_id == $auth.id && $db.subject.ativo == true
      return = {type: "list"}
      output = ["id", "created_at", "updated_at", "user_id", "account_id", "nome", "codigo", "descricao", "creditos", "semestre", "ativo"]
    } as $subjects
  }

  response = $subjects
  tags = ["xano:quick-start"]
}
