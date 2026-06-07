// Update a subject owned by the authenticated user.
query "subjects/{subject_id}" verb=PATCH {
  api_group = "Subjects"
  auth = "user"

  input {
    int subject_id
    text nome?
    text codigo?
    text descricao?
    int creditos?
    int semestre?
    bool ativo?
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
      error = "Access denied to update this subject."
    }

    util.get_all_input as $inputs

    db.patch subjects {
      field_name = "id"
      field_value = $subject.id
      data = $inputs|filter_empty_text:""
      output = ["id", "created_at", "updated_at", "user_id", "account_id", "nome", "codigo", "descricao", "creditos", "semestre", "ativo"]
    } as $updated_subject
  }

  response = $updated_subject
}
