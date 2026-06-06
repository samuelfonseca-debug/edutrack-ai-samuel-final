"""Utility script for calculating task progress and returning JSON output."""

import json
from typing import Any, Dict


def calculate_progress(completed: int, total: int) -> Dict[str, Any]:
    """Calculate progress percentage from completed and total tasks.

    Args:
        completed: Number of completed tasks.
        total: Total number of tasks.

    Returns:
        A dictionary with the progress percentage.
    """
    if total <= 0:
        percentage = 0
    else:
        percentage = round((completed / total) * 100, 2)

    return {
        "completed": completed,
        "total": total,
        "progress_percentage": percentage,
    }


def format_progress_json(completed: int, total: int) -> str:
    """Return the calculated progress as a JSON string."""
    result = calculate_progress(completed, total)
    return json.dumps(result)


if __name__ == "__main__":
    # Example usage: python scripts/calculate_progress.py
    example_result = format_progress_json(0, 0)
    print(example_result)
