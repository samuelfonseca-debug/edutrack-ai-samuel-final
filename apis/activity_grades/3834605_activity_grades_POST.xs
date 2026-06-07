// Record a new grade assignment for a student in a specific activity.
query activity_grades verb=POST {
  api_group = "Activity Grades"
  auth = "user"

  input {
    // The ID of the activity being graded
    int activity_id
  
    // The ID of the student receiving the grade
    int student_id
  
    // The grade value assigned
    decimal grade
  
    // Optional observation about the grade
    text comment?
  }

  stack {
    // Validate required payload fields
    precondition ($input.activity_id != null) {
      error_type = "badrequest"
      error = "activity_id is required"
    }
  
    precondition ($input.student_id != null) {
      error_type = "badrequest"
      error = "student_id is required"
    }
  
    precondition ($input.grade != null) {
      error_type = "badrequest"
      error = "grade is required"
    }
  
    // Retrieve the authenticated user to verify they are a teacher
    db.get user {
      field_name = "id"
      field_value = $auth.id
      output = ["id", "role"]
    } as $teacher
  
    // Verify the authenticated user is a teacher
    precondition ($teacher.role == "professor" || $teacher.role == "teacher") {
      error_type = "accessdenied"
      error = "Only teachers/professors can assign grades."
    }
  
    // Verify the activity exists
    db.get "" {
      field_name = "id"
      field_value = $input.activity_id
    } as $activity
  
    precondition ($activity != null) {
      error_type = "notfound"
      error = "Activity not found."
    }
  
    // Verify the student exists
    db.get user {
      field_name = "id"
      field_value = $input.student_id
    } as $student
  
    precondition ($student != null) {
      error_type = "notfound"
      error = "Student not found."
    }
  
    // Record the grade assignment
    db.add activity_grades {
      data = {
        created_at : "now"
        activity_id: $input.activity_id
        student_id : $input.student_id
        grade      : $input.grade
        teacher_id : $auth.id
        comment    : $input.comment
      }
    
      output = [
        "id"
        "created_at"
        "activity_id"
        "student_id"
        "grade"
        "teacher_id"
        "comment"
      ]
    } as $new_grade
  
    // Log the grade assignment event
    function.run "Getting Started Template/create_event_log" {
      input = {
        user_id : $teacher.id
        action  : "grade_assigned"
        metadata: {
        grade_id   : $new_grade.id
        activity_id: $new_grade.activity_id
        student_id : $new_grade.student_id
        grade      : $new_grade.grade
      }
      }
    } as $event_log
  }

  response = $new_grade
  tags = ["xano:quick-start"]
}