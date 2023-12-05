#!/usr/bin/env python3

import json
import importlib_metadata
import sys

from packaging.requirements import Requirement


def check_requirement(req: str):
    # https://packaging.pypa.io/en/stable/requirements.html
    requirement = Requirement(req)
    try:
        version = importlib_metadata.distribution(requirement.name).version
    except importlib_metadata.PackageNotFoundError:
        print(f"  - Dependency {requirement.name} is missing", file=sys.stderr)
        return False

    # https://packaging.pypa.io/en/stable/specifiers.html
    if not version in requirement.specifier:
        print(
            f"  - {requirement.name}{requirement.specifier} expected, but got {version}",
            file=sys.stderr,
        )
        return False

    return True


def check_manifest(manifest_file: str):
    with open(manifest_file) as fd:
        manifest = json.load(fd)
    if "requirements" in manifest:
        ok = True
        for requirement in manifest["requirements"]:
            ok &= check_requirement(requirement)
        if not ok:
            print("Manifest requirements are not met", file=sys.stderr)
            sys.exit(1)


if __name__ == "__main__":
    if len(sys.argv) < 2:
        raise RuntimeError(f"Usage {sys.argv[0]} <manifest>")
    manifest_file = sys.argv[1]
    check_manifest(manifest_file)
