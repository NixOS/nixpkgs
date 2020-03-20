#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p "python3.withPackages (ps: with ps; [ mypy attrs ])
#
# This script downloads Home Assistant's source tarball.
# Inside the homeassistant/components directory, each integration has an associated manifest.json,
# specifying required packages and other integrations it depends on:
#
#     {
#       "requirements": [ "package==1.2.3" ],
#       "dependencies": [ "component" ]
#     }
#
# By parsing the files, a dictionary mapping integrations to requirements and dependencies is created.
# For all of these requirements and the dependencies' requirements,
# nixpkgs' python3Packages are searched for appropriate names.
# Then, a Nix attribute set mapping integration name to dependencies is created.

import json
import os
import pathlib
import re
import subprocess
import sys
import tarfile
import tempfile
from io import BytesIO
from typing import Dict, Optional
from urllib.request import urlopen

COMPONENT_PREFIX = "homeassistant.components"
PKG_SET = "python3Packages"

# If some requirements are matched by multiple python packages,
# the following can be used to choose one of them
PKG_PREFERENCES = {
    # Use python3Packages.youtube-dl-light instead of python3Packages.youtube-dl
    "youtube-dl": "youtube-dl-light",
    "tensorflow-bin": "tensorflow",
    "tensorflowWithoutCuda": "tensorflow",
}


def run_mypy() -> None:
    cmd = ["mypy", "--ignore-missing-imports", __file__]
    print(f"$ {' '.join(cmd)}")
    subprocess.run(cmd, check=True)


def get_version():
    with open(os.path.dirname(sys.argv[0]) + "/default.nix") as f:
        # A version consists of digits, dots, and possibly a "b" (for beta)
        m = re.search('hassVersion = "([\\d\\.b]+)";', f.read())
        return m.group(1)


def parse_components(version: str = "master"):
    components = {}
    with tempfile.TemporaryDirectory() as tmp:
        with urlopen(
            f"https://github.com/home-assistant/home-assistant/archive/{version}.tar.gz"
        ) as response:
            tarfile.open(fileobj=BytesIO(response.read())).extractall(tmp)
        # Use part of a script from the Home Assistant codebase
        core_path = os.path.join(tmp, f"core-{version}")
        sys.path.append(core_path)
        from script.hassfest.model import Integration

        integrations = Integration.load_dir(
            pathlib.Path(
                os.path.join(core_path, "homeassistant/components")
            )
        )
        for domain in sorted(integrations):
            integration = integrations[domain]
            components[domain] = integration.manifest
    return components


# Recursively get the requirements of a component and its dependencies
def get_reqs(components, component):
    requirements = set(components[component]["requirements"])
    for dependency in components[component]["dependencies"]:
        requirements.update(get_reqs(components, dependency))
    return requirements


def dump_packages() -> Dict[str, Dict[str, str]]:
    # Store a JSON dump of Nixpkgs' python3Packages
    output = subprocess.check_output(
        [
            "nix-env",
            "-f",
            os.path.dirname(sys.argv[0]) + "/../../..",
            "-qa",
            "-A",
            PKG_SET,
            "--json",
        ]
    )
    return json.loads(output)


def name_to_attr_path(req: str, packages: Dict[str, Dict[str, str]]) -> Optional[str]:
    attr_paths = set()
    names = [req]
    # E.g. python-mpd2 is actually called python3.6-mpd2
    # instead of python-3.6-python-mpd2 inside Nixpkgs
    if req.startswith("python-") or req.startswith("python_"):
        names.append(req[len("python-") :])
    for name in names:
        # treat "-" and "_" equally
        name = re.sub("[-_]", "[-_]", name)
        pattern = re.compile("^python\\d\\.\\d-{}-\\d".format(name), re.I)
        for attr_path, package in packages.items():
            if pattern.match(package["name"]):
                attr_paths.add(attr_path)
    if len(attr_paths) > 1:
        for to_replace, replacement in PKG_PREFERENCES.items():
            try:
                attr_paths.remove(PKG_SET + "." + to_replace)
                attr_paths.add(PKG_SET + "." + replacement)
            except KeyError:
                pass
    # Let's hope there's only one derivation with a matching name
    assert len(attr_paths) <= 1, "{} matches more than one derivation: {}".format(
        req, attr_paths
    )
    if len(attr_paths) == 1:
        return attr_paths.pop()
    else:
        return None


def main() -> None:
    packages = dump_packages()
    version = get_version()
    print("Generating component-packages.nix for version {}".format(version))
    components = parse_components(version=version)
    build_inputs = {}
    for component in sorted(components.keys()):
        attr_paths = []
        missing_reqs = []
        reqs = sorted(get_reqs(components, component))
        for req in reqs:
            # Some requirements are specified by url, e.g. https://example.org/foobar#xyz==1.0.0
            # Therefore, if there's a "#" in the line, only take the part after it
            req = req[req.find("#") + 1 :]
            name = req.split("==")[0]
            attr_path = name_to_attr_path(name, packages)
            if attr_path is not None:
                # Add attribute path without "python3Packages." prefix
                attr_paths.append(attr_path[len(PKG_SET + ".") :])
            else:
                missing_reqs.append(name)
        else:
            build_inputs[component] = (attr_paths, missing_reqs)
        n_diff = len(reqs) > len(build_inputs[component])
        if n_diff > 0:
            print("Component {} is missing {} dependencies".format(component, n_diff))
            print("missing requirements: {}".format(missing_reqs))

    with open(os.path.dirname(sys.argv[0]) + "/component-packages.nix", "w") as f:
        f.write("# Generated by parse-requirements.py\n")
        f.write("# Do not edit!\n\n")
        f.write("{\n")
        f.write(f'  version = "{version}";\n')
        f.write("  components = {\n")
        for component, deps in build_inputs.items():
            available, missing = deps
            f.write(f'    "{component}" = ps: with ps; [ ')
            f.write(" ".join(available))
            f.write("];")
            if len(missing) > 0:
                f.write(f" # missing inputs: {' '.join(missing)}")
            f.write("\n")
        f.write("  };\n")
        f.write("}\n")


if __name__ == "__main__":
    run_mypy()
    main()
