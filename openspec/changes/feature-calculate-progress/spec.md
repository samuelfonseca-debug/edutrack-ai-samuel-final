# calculate_progress Specification

## Purpose
Define the behavior of a Python script that computes a progress percentage from completed and total task counts and returns the output as JSON.

## ADDED Requirements
### Requirement: Compute progress percentage
The system SHALL calculate progress as `completed / total` and express it as a numeric percentage.
#### Scenario: Calculate progress for normal input
- **WHEN** the script receives completed and total task counts
- **THEN** it calculates the correct progress percentage

### Requirement: Handle zero total safely
The system SHALL handle the case where `total` is zero without raising an error.
#### Scenario: Calculate progress when total is zero
- **WHEN** the total task count is zero
- **THEN** the script returns a progress percentage of `0` or a safe default in JSON

### Requirement: Return JSON output
The system SHALL return the progress result as valid JSON.
#### Scenario: Return progress as JSON
- **WHEN** the calculation is complete
- **THEN** the output is serialized as valid JSON with the percentage field
