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
  
    // Due date for the academic task
    date due_date
  
    text status filters=trim
  
    // Reference to the associated academic subject
    int subject_id {
      table = "subject"
    }
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree", field: [{name: "subject_id", op: "asc"}]}
  ]

  tags = ["xano:quick-start"]
}