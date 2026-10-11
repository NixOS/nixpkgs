from __future__ import annotations

import argparse
import json
import subprocess
import sys
from dataclasses import dataclass
from difflib import unified_diff
from pathlib import Path
from textwrap import indent
from tempfile import TemporaryDirectory


def load_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("file", type=Path, help="The test file to evaluate")
    return parser.parse_args()


def main():
    args = load_args()
    if not TestFixture.run_all(args.file):
        sys.exit(1)


@dataclass
class TestFixture:
    "A test fixture in a test file"

    file: Path
    attr: str
    name: str
    stdout: str | None
    stderr: str | None
    exit: int
    has_test_fn: bool

    def run(self) -> bool:
        with TemporaryDirectory() as td:
            td = Path(td)
            stdout = td / "stdout"
            stderr = td / "stderr"

            with stdout.open("wb") as outf, stderr.open("wb") as errf:
                result = subprocess.run(
                    [
                        "nix-instantiate",
                        "--eval",
                        self.file,
                        "--arg",
                        "pkgs",
                        "import <nixpkgs> { }",
                        "--arg",
                        "lib",
                        "import <nixpkgs/lib>",
                        "--attr",
                        f"{self.attr}.expr",
                    ],
                    stdout=outf,
                    stderr=errf,
                )

            errors = []

            if self.exit is not None and self.exit != result.returncode:
                errors.append(
                    indent(
                        f"- Incorrect exit code. Expected {self.exit}, actual {result.returncode}",
                        "  ",
                    )
                )

            if self.stdout is not None:
                text = stdout.read_text()
                if self.stdout != text:
                    expected = self.stdout.splitlines(keepends=True)
                    actual = text.splitlines(keepends=True)
                    diff = unified_diff(
                        expected, actual, fromfile="expected", tofile="actual"
                    )
                    errors.append(
                        indent(
                            f"- Incorrect stdout:\n{indent(''.join(diff), '  ')}", "  "
                        )
                    )

            if self.stderr is not None:
                text = stderr.read_text()
                if self.stderr != text:
                    expected = self.stderr.splitlines(keepends=True)
                    actual = text.splitlines(keepends=True)
                    diff = unified_diff(
                        expected, actual, fromfile="expected", tofile="actual"
                    )
                    errors.append(
                        indent(
                            f"- Incorrect stderr:\n{indent(''.join(diff), '  ')}", "  "
                        )
                    )

            if self.has_test_fn:
                test_result = subprocess.run(
                    [
                        "nix-instantiate",
                        "--eval",
                        self.file,
                        "--arg",
                        "pkgs",
                        "import <nixpkgs> { }",
                        "--arg",
                        "lib",
                        "import <nixpkgs/lib>",
                        "--attr",
                        f"{self.attr}.test",
                        "--arg",
                        "exit",
                        f"{result.returncode}",
                        "--argstr",
                        "stdoutFile",
                        stdout,
                        "--argstr",
                        "stderrFile",
                        stderr,
                    ],
                    stdout=subprocess.PIPE,
                    stderr=subprocess.STDOUT,
                    text=True,
                )
                if test_result.returncode != 0:
                    errors.append(
                        indent(
                            (
                                f"- Test function failed: exit {test_result.returncode}:\n"
                                f"{indent(test_result.stdout, '  ')}"
                            ),
                            "  ",
                        )
                    )

            if errors != []:
                print(f"- {self.name} FAILED", file=sys.stderr)
                print("\n".join(errors), file=sys.stderr)
                return False

            print(f"- {self.name} OK", file=sys.stderr)
            return True

    @classmethod
    def run_all(cls, file: Path) -> bool:
        ok = True
        print(f"Running {file.stem}", file=sys.stderr)
        for attr, test in cls.load_all(file).items():
            ok = test.run() and ok
        return ok

    @classmethod
    def load_all(cls, file: Path) -> dict[str, TestFixture]:
        expr = """
        { file }:
        let
          fn = import file;
          autoArgs = {
            pkgs = import <nixpkgs> { };
            lib = import <nixpkgs/lib>;
          };
          args = builtins.intersectAttrs (builtins.functionArgs fn) autoArgs;
          attrs = if builtins.isFunction fn then fn args else fn;
        in
        builtins.mapAttrs (
          attr:
          {
            name ? attr,
            expr, # do not eval yet
            stdout ? "true\\n",
            stderr ? null,
            exit ? 0,
            test ? null,
          }@args:
          {
            inherit name stdout stderr exit;
            hasTestFn = args ? test;
          }
        ) attrs
        """

        with subprocess.Popen(
            [
                "nix-instantiate",
                "--eval",
                "--strict",
                "--json",
                "--argstr",
                "file",
                file,
                "--expr",
                expr,
            ],
            stdout=subprocess.PIPE,
            stderr=sys.stderr,
        ) as proc:
            ok = True
            try:
                data = json.load(proc.stdout)
            except json.JSONDecodeError:
                ok = False

            returncode = proc.wait()
            if not (ok and returncode == 0):
                raise subprocess.CalledProcessError(
                    cmd=f"load {file}",
                    returncode=returncode,
                )

        return {
            attr: cls(
                file=file,
                attr=attr,
                name=test["name"],
                stdout=test["stdout"],
                stderr=test["stderr"],
                exit=test["exit"],
                has_test_fn=test["hasTestFn"],
            )
            for attr, test in data.items()
        }


if __name__ == "__main__":
    main()
