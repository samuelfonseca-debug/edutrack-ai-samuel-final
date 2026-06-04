import os
import re
import unittest

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))


def load_file(relative_path: str) -> str:
    file_path = os.path.join(ROOT, *relative_path.split("/"))
    with open(file_path, encoding="utf-8") as file:
        return file.read()


class TestSubjectBehavior(unittest.TestCase):
    def test_subject_table_schema(self):
        content = load_file("tables/816581_subject.xs")

        self.assertIn("table subject", content)
        self.assertIn("bool ativo?=true", content)
        self.assertRegex(content, r"user_id\s*\{[\s\S]*?table\s*=\s*\"user\"", msg=content)
        self.assertRegex(content, r"account_id\?\s*\{[\s\S]*?table\s*=\s*\"account\"", msg=content)
        self.assertRegex(content, r"\{type: \"btree\", field: \[\{name: \"user_id\"", msg=content)
        self.assertRegex(content, r"\{type: \"btree\", field: \[\{name: \"account_id\"", op: \"asc\"\}, \{name: \"ativo\"", op: \"asc\"\}\]", msg=content)
        self.assertRegex(content, r"\{type: \"btree\", field: \[\{name: \"codigo\"", op: \"asc\"\}\]", msg=content)

    def test_get_subjects_lists_active_subjects_for_user(self):
        content = load_file("apis/subjects/3834600_subjects_GET.xs")

        self.assertIn("auth = \"user\"", content)
        self.assertIn("where = $db.subject.user_id == $auth.id && $db.subject.ativo == true", content)
        self.assertIn("return = {type: \"list\"}", content)

    def test_create_subject_records_user_account_and_event(self):
        content = load_file("apis/subjects/3834601_subjects_POST.xs")

        self.assertIn("auth = \"user\"", content)
        self.assertIn("account_id : $user.account_id", content)
        self.assertIn("action    : \"subject_created\"", content)
        self.assertIn("metadata  : {subject_id: $new_subject.id", content)

    def test_get_subject_by_id_validates_user_and_account(self):
        content = load_file("apis/subjects/3834602_subjects_subject_id_GET.xs")

        self.assertIn("auth = \"user\"", content)
        self.assertIn("precondition ($subject.user_id == $auth.id)", content)
        self.assertIn("precondition ($subject.account_id == $user.account_id)", content)

    def test_update_subject_uses_filtered_inputs_and_logs_event(self):
        content = load_file("apis/subjects/3834603_subjects_subject_id_PATCH.xs")

        self.assertIn("auth = \"user\"", content)
        self.assertIn("util.get_all_input as $inputs", content)
        self.assertIn("data = $inputs|filter_empty_text:\"\"", content)
        self.assertIn("action    : \"subject_updated\"", content)

    def test_delete_subject_marks_inactive_and_logs_event(self):
        content = load_file("apis/subjects/3834604_subjects_subject_id_DELETE.xs")

        self.assertIn("auth = \"user\"", content)
        self.assertIn("data = {ativo: false, updated_at: \"now\"}", content)
        self.assertIn("action    : \"subject_deleted\"", content)


if __name__ == "__main__":
    unittest.main()
