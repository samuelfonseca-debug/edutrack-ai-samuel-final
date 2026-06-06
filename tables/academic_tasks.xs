// Stores academic tasks linked to academic subjects for student obligations.
table academic_tasks {
  auth = false

  schema {
    int id
    timestamp created_at?=now {
      visibility = "private"
    }

    text title filters=trim
    text description? filters=trim
    date due_date {
      description = "Due date for the academic task"
    }
    text status filters=trim

    int subject_id {
      table = "subject"
      description = "Reference to the associated academic subject"
    }
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree", field: [{name: "subject_id", op: "asc"}]}
  ]

  tags = ["xano:quick-start"]
}
