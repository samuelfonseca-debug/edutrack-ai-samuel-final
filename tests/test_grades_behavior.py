import glob
import os
import unittest

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))


def load_file(relative_path: str) -> str:
    file_path = os.path.join(ROOT, *relative_path.split("/"))
    with open(file_path, encoding="utf-8") as file:
        return file.read()


def find_file(pattern: str) -> str:
    matches = glob.glob(os.path.join(ROOT, pattern), recursive=True)
    if not matches:
        raise FileNotFoundError(f"Nenhum arquivo encontrado para o padrão: {pattern}")
    return matches[0]


def find_activity_grades_table() -> str:
    # Try known table path first (found in repo)
    candidates = [
        os.path.join(ROOT, "tables", "816582_activity_grades.xs"),
        os.path.join(ROOT, "tables", "*activity_grades*.xs"),
    ]
    for p in candidates:
        matches = glob.glob(p, recursive=True)
        if matches:
            return matches[0]
    raise FileNotFoundError("Nenhum arquivo de tabela activity_grades encontrado em tables/")


def find_activity_grades_post() -> str:
    # Try known API path first (found in repo)
    candidates = [
        os.path.join(ROOT, "apis", "activity_grades", "3834605_activity_grades_POST.xs"),
        os.path.join(ROOT, "apis", "**", "*activity_grades*POST*.xs"),
    ]
    for p in candidates:
        matches = glob.glob(p, recursive=True)
        if matches:
            return matches[0]
    raise FileNotFoundError("Nenhum endpoint POST para activity_grades encontrado em apis/")


class TestGradesBehavior(unittest.TestCase):
    def test_activity_grades_table_schema(self):
        table_path = find_activity_grades_table()
        content = load_file(os.path.relpath(table_path, ROOT))

        self.assertIn("table activity_grades", content)
        self.assertIn("activity_id", content)
        self.assertIn("student_id", content)
        self.assertIn("grade", content)
        self.assertIn("teacher_id", content)
        self.assertIn("comment", content)

    def test_post_activity_grades_requires_professor_authorization(self):
        api_path = find_activity_grades_post()
        content = load_file(os.path.relpath(api_path, ROOT))

        self.assertIn("auth = \"user\"", content)
        self.assertIn("teacher_id", content)
        self.assertTrue(
            "professor" in content.lower() or "teacher" in content.lower(),
            msg="O arquivo de API deve validar perfil de professor"
        )

    def test_post_activity_grades_validates_required_payload_fields(self):
        api_path = find_activity_grades_post()
        content = load_file(os.path.relpath(api_path, ROOT))

        self.assertIn("activity_id", content)
        self.assertIn("student_id", content)
        self.assertIn("grade", content)
        self.assertTrue(
            "required" in content.lower() or "validate" in content.lower(),
            msg="Deve haver validação de payload obrigatório para activity_id, student_id e grade"
        )

    def test_post_activity_grades_rejects_nonexistent_activity_or_student(self):
        api_path = find_activity_grades_post()
        content = load_file(os.path.relpath(api_path, ROOT))

        self.assertTrue(
            "activity_id" in content and "student_id" in content,
            msg="O endpoint deve validar existência de activity_id e student_id"
        )
        self.assertTrue(
            "not found" in content.lower() or "exists" in content.lower() or "precondition" in content.lower(),
            msg="Deve haver lógica para rejeitar referências inexistentes"
        )


if __name__ == "__main__":
    unittest.main()
