# Subject Search Specification

## Purpose
Provide a search endpoint for `subjects` that supports filtering by subject name or by overdue academic tasks, while enforcing per-user authorization.

## Requirements

### Search by name or overdue tasks
- The system SHALL expose a search endpoint for subjects.
- The search endpoint SHALL accept optional query parameters to filter by:
  - `nome` — partial match on the subject name
  - `overdue_tasks` — a boolean flag to return only subjects that have at least one overdue task
- The endpoint SHALL return results when either filter is present, and when both are present it SHALL return subjects matching the name filter OR subjects that have overdue tasks.

### Authorization
- The endpoint SHALL require authentication (`auth = "user"`).
- The endpoint SHALL return only subjects owned by the authenticated user.
- The endpoint SHALL NOT expose subjects from other users.

### Overdue task logic
- A subject is considered to have overdue tasks when there is at least one related `academic_tasks` record satisfying:
  - `subject_id` references the subject
  - `due_date` is before the current date
  - the task is not completed (or the status field indicates pending/not finished)
- The overdue calculation SHALL be performed by integrating Python-based business logic, separated from the query filter.

### Response
- The endpoint SHALL return a list of subjects with fields at minimum:
  - `id`
  - `nome`
  - `codigo`
  - `descricao`
  - `creditos`
  - `semestre`
  - `ativo`
  - optionally `overdue_task_count` or `has_overdue_tasks`

## Scenarios

### Search subjects by name
- WHEN an authenticated user calls `GET /subjects/search?nome=math`
- THEN return only subjects owned by that user whose `nome` contains `math`.

### Search subjects with overdue tasks
- WHEN an authenticated user calls `GET /subjects/search?overdue_tasks=true`
- THEN return only subjects owned by that user that have overdue academic tasks.

### Search subjects by name OR overdue tasks
- WHEN an authenticated user calls `GET /subjects/search?nome=math&overdue_tasks=true`
- THEN return subjects owned by that user that match the name search OR have overdue tasks.

## Notes
- If the user does not pass any filter, the endpoint MAY default to returning all active subjects for the user or require at least one filter.
- The Python integration should be implemented as a reusable helper script or function to keep overdue-task detection separate from the API query.
