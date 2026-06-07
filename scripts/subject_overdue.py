"""Subject overdue task detection helper.

This module provides helper functions to determine which subjects have overdue academic tasks.
"""

import json
from datetime import date, datetime
from typing import Any, Dict, Iterable, List, Optional, Set, Union


def parse_date(value: Union[str, date, datetime]) -> date:
    if isinstance(value, date) and not isinstance(value, datetime):
        return value
    if isinstance(value, datetime):
        return value.date()
    text = str(value).strip()
    if "T" in text:
        return datetime.fromisoformat(text).date()
    return date.fromisoformat(text)


def is_task_overdue(task: Dict[str, Any], now: Optional[date] = None) -> bool:
    """Return True when the task is overdue and not completed."""
    if now is None:
        now = date.today()

    status = str(task.get("status", "")).strip().lower()
    if status in {"completed", "done", "finished"}:
        return False

    due_date_value = task.get("due_date")
    if due_date_value is None:
        return False

    try:
        due_date = parse_date(due_date_value)
    except ValueError:
        return False

    return due_date < now


def overdue_subject_ids(
    tasks: Iterable[Dict[str, Any]],
    now: Optional[date] = None,
    completed_statuses: Optional[Set[str]] = None,
) -> Set[int]:
    """Return subject IDs that have at least one overdue task."""
    if completed_statuses is None:
        completed_statuses = {"completed", "done", "finished"}
    if now is None:
        now = date.today()

    result: Set[int] = set()
    for task in tasks:
        status = str(task.get("status", "")).strip().lower()
        if status in completed_statuses:
            continue
        due_date_value = task.get("due_date")
        if due_date_value is None:
            continue
        try:
            due_date = parse_date(due_date_value)
        except ValueError:
            continue
        if due_date < now:
            subject_id = task.get("subject_id")
            if isinstance(subject_id, int):
                result.add(subject_id)
            else:
                try:
                    result.add(int(subject_id))
                except (ValueError, TypeError):
                    continue
    return result


def filter_subjects(
    subjects: Iterable[Dict[str, Any]],
    tasks: Iterable[Dict[str, Any]],
    nome: Optional[str] = None,
    overdue_tasks: bool = False,
    now: Optional[date] = None,
) -> List[Dict[str, Any]]:
    """Return subjects filtered by nome or overdue task status."""
    nome_text = str(nome).strip().lower() if nome else None
    overdue_ids = overdue_subject_ids(tasks, now=now)

    filtered: List[Dict[str, Any]] = []
    seen: Set[int] = set()
    for subject in subjects:
        subject_id = subject.get("id")
        if not isinstance(subject_id, int):
            try:
                subject_id = int(subject_id)
            except (ValueError, TypeError):
                continue

        matches_name = False
        if nome_text:
            subject_nome = str(subject.get("nome", "")).strip().lower()
            matches_name = nome_text in subject_nome

        matches_overdue = overdue_tasks and subject_id in overdue_ids

        if nome_text and overdue_tasks:
            if matches_name or matches_overdue:
                if subject_id not in seen:
                    seen.add(subject_id)
                    filtered.append(subject)
        elif nome_text:
            if matches_name:
                if subject_id not in seen:
                    seen.add(subject_id)
                    filtered.append(subject)
        elif overdue_tasks:
            if matches_overdue:
                if subject_id not in seen:
                    seen.add(subject_id)
                    filtered.append(subject)
        else:
            if subject_id not in seen:
                seen.add(subject_id)
                filtered.append(subject)

    return filtered


def format_subjects_json(subjects: Iterable[Dict[str, Any]]) -> str:
    return json.dumps({"subjects": list(subjects)}, default=str)


if __name__ == "__main__":
    print(format_subjects_json([]))
