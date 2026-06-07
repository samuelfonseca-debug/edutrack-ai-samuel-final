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
    db.add subjects {
      data = {
        created_at : "now"
        updated_at : "now"
        user_id    : $auth.id
        account_id : $auth.account_id
        nome       : $input.nome
        codigo     : $input.codigo
        descricao  : $input.descricao
        creditos   : $input.creditos
        semestre   : $input.semestre
        ativo      : true
      }
      output = ["id", "created_at", "updated_at", "user_id", "account_id", "nome", "codigo", "descricao", "creditos", "semestre", "ativo"]
    } as $new_subject
  }

  response = $new_subject
}
