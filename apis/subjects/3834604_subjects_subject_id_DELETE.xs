// Deactivate a subject by marking it as inactive.
query "subjects/{subject_id}" verb=DELETE {
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
      error = "Access denied to delete this subject."
    }

    precondition ($subject.account_id == $user.account_id) {
      error_type = "accessdenied"
      error = "Access denied to this account's subject."
    }

    db.patch subject {
      field_name = "id"
      field_value = $subject.id
      data = {ativo: false, updated_at: "now"}
      output = ["id", "created_at", "updated_at", "user_id", "account_id", "nome", "codigo", "descricao", "creditos", "semestre", "ativo"]
    } as $deleted_subject

    function.run "Getting Started Template/create_event_log" {
      input = {
        user_id   : $auth.id
        account_id: $user.account_id
        action    : "subject_deleted"
        metadata  : {subject_id: $deleted_subject.id, nome: $deleted_subject.nome, codigo: $deleted_subject.codigo}
      }
    } as $event_log
  }

  response = $deleted_subject
  tags = ["xano:quick-start"]
}
