import importlib.util
import unittest
from pathlib import Path


SCRIPT = Path(__file__).with_name("update-liquorix.py")
SPEC = importlib.util.spec_from_file_location("update_liquorix", SCRIPT)
UPDATE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(UPDATE)


class LiquorixUpdaterTests(unittest.TestCase):
    def test_selects_latest_stable_liquorix_release(self):
        releases = [
            {"tag_name": "v7.1.4-zen1"},
            {"tag_name": "v7.1.3-lqx3", "draft": False, "prerelease": False},
            {"tag_name": "v7.1.4-lqx1", "draft": False, "prerelease": False},
            {"tag_name": "v7.2-lqx1", "draft": False, "prerelease": True},
        ]
        release = UPDATE.select_latest_release(releases)
        self.assertEqual(release["version"], "7.1.4")
        self.assertEqual(release["suffix"], "lqx1")

    def test_revision_orders_numerically(self):
        releases = [
            {"tag_name": "v7.1.4-lqx2"},
            {"tag_name": "v7.1.4-lqx10"},
        ]
        self.assertEqual(
            UPDATE.select_latest_release(releases)["suffix"],
            "lqx10",
        )

    def test_render_updates_only_source_fields(self):
        original = """
  suffix = "lqx1";
    version = "7.1.3";
      sha256 = "old";
"""
        rendered = UPDATE.render_package(original, "7.1.4", "lqx2", "new")
        self.assertIn('suffix = "lqx2";', rendered)
        self.assertIn('version = "7.1.4";', rendered)
        self.assertIn('sha256 = "new";', rendered)

    def test_config_report_detects_policy_drift(self):
        config = "\n".join(
            f"{key}={value}" if value != "n" else f"# {key} is not set"
            for key, value in UPDATE.CONFIG_POLICY.items()
        )
        report = UPDATE.config_report("7.1.4", config)
        self.assertEqual(report["drift"], {})

        report = UPDATE.config_report(
            "7.1.4",
            config.replace("CONFIG_HZ=1000", "CONFIG_HZ=250"),
        )
        self.assertEqual(report["drift"]["CONFIG_HZ"]["actual"], "250")


if __name__ == "__main__":
    unittest.main()
