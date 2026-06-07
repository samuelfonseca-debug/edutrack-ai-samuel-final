# subjects Specification
## Purpose
Define CRUD endpoints for managing `subjects` ensuring each user can access only their own records.
## ADDED Requirements
### Requirement: Subjects CRUD endpoints
The system SHALL provide CRUD endpoints for the `subjects` resource scoped to the authenticated user.
#### Scenario: Create subject
- **WHEN** an authenticated user submits `POST /subjects` with valid subject data
- **THEN** the system creates a `subject` record with `user_id` set to the authenticated user's id and returns the created resource

#### Scenario: List subjects
- **WHEN** an authenticated user calls `GET /subjects`
- **THEN** the system returns only `subject` records where `user_id` equals the authenticated user's id and `ativo` is true

#### Scenario: Get subject by id
- **WHEN** an authenticated user calls `GET /subjects/{subject_id}`
- **THEN** the system returns the subject only if its `user_id` equals the authenticated user's id and it exists

#### Scenario: Update subject
- **WHEN** an authenticated user calls `PATCH /subjects/{subject_id}` with changes
- **THEN** the system updates the subject only if its `user_id` equals the authenticated user's id

#### Scenario: Delete (deactivate) subject
- **WHEN** an authenticated user calls `DELETE /subjects/{subject_id}`
- **THEN** the system marks the subject as inactive (`ativo=false`) only if its `user_id` equals the authenticated user's id

### Security
1. All endpoints SHALL require authentication (`auth = "user"`).
2. All data access SHALL be restricted by `user_id == $auth.id` and additionally verify `account_id` where applicable.
3. Responses for missing/unauthorized resources SHALL use consistent error types (`notfound`, `accessdenied`).
