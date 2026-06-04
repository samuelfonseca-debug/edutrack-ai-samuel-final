// Create a new subject for the authenticated user.
query "subjects" verb=POST {
  api_group = "Subjects"
  auth = "user"

  input {
    text nome
    text codigo?
    text descricao?
    int creditos?
    int semestre?
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

    db.add subject {
      data = {
        created_at : "now"
        updated_at : "now"
        user_id    : $auth.id
        account_id : $user.account_id
        nome       : $input.nome
        codigo     : $input.codigo
        descricao  : $input.descricao
        creditos   : $input.creditos
        semestre   : $input.semestre
        ativo      : true
      }
      output = ["id", "created_at", "updated_at", "user_id", "account_id", "nome", "codigo", "descricao", "creditos", "semestre", "ativo"]
    } as $new_subject

    function.run "Getting Started Template/create_event_log" {
      input = {
        user_id   : $auth.id
        account_id: $user.account_id
        action    : "subject_created"
        metadata  : {subject_id: $new_subject.id, nome: $new_subject.nome, codigo: $new_subject.codigo}
      }
    } as $event_log
  }

  response = $new_subject
  tags = ["xano:quick-start"]
}
