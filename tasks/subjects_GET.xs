// List active subjects for the authenticated user.
query "subjects" verb=GET {
  api_group = "Subjects"
  auth = "user"

  input {
  }

  stack {
    db.query subjects {
      where = $db.subjects.user_id == $auth.id && $db.subjects.ativo == true
      return = {type: "list"}
      output = ["id", "created_at", "updated_at", "user_id", "account_id", "nome", "codigo", "descricao", "creditos", "semestre", "ativo"]
    } as $subjects
  }

  response = $subjects
}
