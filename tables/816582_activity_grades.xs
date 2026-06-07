// Stores activity grades assigned by teachers to students for specific academic tasks.
table activity_grades {
  auth = false

  schema {
    int id
    timestamp created_at?=now {
      visibility = "private"
    }
  
    int activity_id {
      table = ""
    }
  
    int student_id {
      table = "user"
    }
  
    // Grade value assigned to the student
    decimal grade
  
    // Reference to the teacher who assigned the grade
    int teacher_id {
      table = "user"
    }
  
    // Optional observation about the grade assignment
    text comment? filters=trim
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree", field: [{name: "activity_id", op: "asc"}]}
    {type: "btree", field: [{name: "student_id", op: "asc"}]}
    {type: "btree", field: [{name: "teacher_id", op: "asc"}]}
    {
      type : "btree"
      field: [
        {name: "activity_id", op: "asc"}
        {name: "student_id", op: "asc"}
      ]
    }
  ]

  tags = ["xano:quick-start"]
}