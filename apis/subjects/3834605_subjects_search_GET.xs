// Search subjects by name or overdue academic tasks for the authenticated user.
query "subjects/search" verb=GET {
  api_group = "Subjects"
  auth = "user"

  input {
    text nome? filters=trim
    bool overdue_tasks?
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

    // Retrieve all active subjects owned by the authenticated user.
    db.direct_query {
      sql = """
        select distinct
          s.id,
          s.created_at,
          s.updated_at,
          s.user_id,
          s.account_id,
          s.nome,
          s.codigo,
          s.descricao,
          s.creditos,
          s.semestre,
          s.ativo,
          exists (
            select 1
            from academic_tasks t
            where t.subject_id = s.id
              and t.due_date < current_date
              and lower(trim(t.status)) != 'completed'
          ) as has_overdue_tasks
        from subject s
        where s.user_id = ?
          and s.ativo = true
          and (
            ((? is null or ? = '') and (? is null or ? = false))
            or lower(s.nome) like ('%' || lower(?) || '%')
            or (? = true and exists (
              select 1
              from academic_tasks t
              where t.subject_id = s.id
                and t.due_date < current_date
                and lower(trim(t.status)) != 'completed'
            ))
          )
      """
      response_type = "list"
      arg = [$auth.id, $input.nome, $input.nome, $input.overdue_tasks, $input.overdue_tasks, $input.nome, $input.overdue_tasks]
    } as $subjects
  }

  response = {
    subjects : $subjects
    note     : "has_overdue_tasks is included per subject; use scripts/subject_overdue.py for reusable overdue-task detection logic."
  }
  tags = ["xano:quick-start"]
}
