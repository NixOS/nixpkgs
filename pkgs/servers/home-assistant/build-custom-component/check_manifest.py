#!/usr/bin/env python3

import argparse
import json
import os
import sys

import importlib.metadata
from typing import Dict, List
from packaging.requirements import InvalidRequirement, Requirement


def error(msg: str, ret: bool = False) -> bool:
    print(f"  - {msg}", file=sys.stderr)
    return ret


def check_derivation_name(manifest: Dict) -> bool:
    derivation_domain = os.environ.get("domain")
    manifest_domain = manifest["domain"]
    if derivation_domain != manifest_domain:
        return error(
            f"Derivation attribute domain ({derivation_domain}) should match manifest domain ({manifest_domain})"
        )
    return True


def test_requirement(req: str, ignore_version_requirement: List[str]) -> bool:
    # https://packaging.pypa.io/en/stable/requirements.html
    try:
        requirement = Requirement(req)
    except InvalidRequirement:
        return error(f"{req} could not be parsed", ret=True)

    try:
        version = importlib.metadata.distribution(requirement.name).version
    except importlib.metadata.PackageNotFoundError:
        return error(f"{requirement.name}{requirement.specifier} not installed")

    # https://packaging.pypa.io/en/stable/specifiers.html
    if (
        requirement.name not in ignore_version_requirement
        and version not in requirement.specifier
    ):
        return error(
            f"{requirement.name}{requirement.specifier} not satisfied by version {version}"
        )

    return True


def check_requirements(manifest: Dict, ignore_version_requirement: List[str]):
    ok = True

    for requirement in manifest.get("requirements", []):
        ok &= test_requirement(requirement, ignore_version_requirement)

    return ok


def main(args):
    ok = True

    manifests = []
    for fd in args.manifests:
        manifests.append(json.load(fd))

    # At least one manifest should match the component name
    ok &= any(check_derivation_name(manifest) for manifest in manifests)

    # All requirements need to match, use `ignoreVersionRequirement` to ignore too strict version constraints
    ok &= all(
        check_requirements(manifest, args.ignore_version_requirement)
        for manifest in manifests
    )

    if not ok:
        sys.exit(1)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("manifests", type=argparse.FileType("r"), nargs="+")
    parser.add_argument("--ignore-version-requirement", action="append", default=[])
    args = parser.parse_args()

    main(args)
