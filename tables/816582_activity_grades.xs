// Stores activity grades assigned by teachers to students for specific academic tasks.
table activity_grades {
  auth = false

  schema {
    int id
    timestamp created_at?=now {
      visibility = "private"
    }

    int activity_id {
      table = "academic_task"
    }

    int student_id {
      table = "user"
    }

    decimal grade {
      description = "Grade value assigned to the student"
    }

    int teacher_id {
      table = "user"
      description = "Reference to the teacher who assigned the grade"
    }

    text comment? filters=trim {
      description = "Optional observation about the grade assignment"
    }
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree", field: [{name: "activity_id", op: "asc"}]}
    {type: "btree", field: [{name: "student_id", op: "asc"}]}
    {type: "btree", field: [{name: "teacher_id", op: "asc"}]}
    {type: "btree", field: [{name: "activity_id", op: "asc"}, {name: "student_id", op: "asc"}]}
  ]

  tags = ["xano:quick-start"]
}
