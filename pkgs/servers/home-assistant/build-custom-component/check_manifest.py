#!/usr/bin/env python3

import json
import os
import sys

import importlib_metadata
from packaging.requirements import InvalidRequirement, Requirement


def error(msg: str, ret: bool = False) -> None:
    print(f"  - {msg}", file=sys.stderr)
    return ret


def check_requirement(req: str):
    # https://packaging.pypa.io/en/stable/requirements.html
    try:
        requirement = Requirement(req)
    except InvalidRequirement:
        return error(f"{req} could not be parsed", ret=True)

    try:
        version = importlib_metadata.distribution(requirement.name).version
    except importlib_metadata.PackageNotFoundError:
        return error(f"{requirement.name}{requirement.specifier} not present")

    # https://packaging.pypa.io/en/stable/specifiers.html
    if version not in requirement.specifier:
        return error(
            f"{requirement.name}{requirement.specifier} expected, but got {version}"
        )

    return True


def check_manifest(manifest_file: str):
    with open(manifest_file) as fd:
        manifest = json.load(fd)

    ok = True

    derivation_domain = os.environ.get("domain")
    manifest_domain = manifest["domain"]
    if derivation_domain != manifest_domain:
        ok = False
        error(
            f"Derivation attribute domain ({derivation_domain}) must match manifest domain ({manifest_domain})"
        )

    if "requirements" in manifest:
        for requirement in manifest["requirements"]:
            ok &= check_requirement(requirement)

    if not ok:
        error("Manifest check failed.")
        sys.exit(1)


if __name__ == "__main__":
    if len(sys.argv) < 2:
        raise RuntimeError(f"Usage {sys.argv[0]} <manifest>")
    manifest_file = sys.argv[1]
    check_manifest(manifest_file)
