#!/usr/bin/env nix-shell
#! nix-shell -i python -p "python3.withPackages (ps: with ps; [ pyyaml ])"

import os
import sys
import re
from pathlib import Path
import yaml

frameworks = []
pattern1 = re.compile("#(?:import|include) <(\w+)/\w+\.h>")
pattern2 = re.compile('#(?:import|include) \S+/(\w+)\.framework/\S+')
yaml.add_constructor("!tapi-tbd-v2", lambda loader, node: loader.construct_mapping(node))

IGNORED_LIBS = ("os", "sys", "dispatch", "mach", "libkern", "bsm", "uuid")


class Framework:
    def __init__(self, path):
        self.path = path
        self.parse_name()
        self.parse_Current()
        self.parse_subFramework()
        self.parse_propagatedBuildInputs()
        self.parse_re_exports()

    def __repr__(self):
        return f"{self.name}"

    def parse_name(self):
        self.name = self.path.stem

    def parse_Current(self):
        # In some cases a framework may contain several versions, we choose the newest one.
        versions = sorted(self.path.glob("Versions/*"))
        self.Current = versions[-1].name if versions else None

    def parse_subFramework(self):
        for subpath in self.path.glob(f"Versions/{self.Current}/*Frameworks/*.framework"):
            frameworks.append(Framework(subpath))

    def parse_propagatedBuildInputs(self):
        # we don't know what a framework depends, so guessing form headers.
        self.propagatedBuildInputs = set()
        for header in self.path.glob(f"Versions/{self.Current}/*Headers/*.h"):
            self.propagatedBuildInputs.update(pattern1.findall(header.read_text(errors="ignore")))
            self.propagatedBuildInputs.update(pattern2.findall(header.read_text(errors="ignore")))

        # drop self-depend and unneeded
        self.propagatedBuildInputs.discard(self.name)
        self.propagatedBuildInputs.difference_update(IGNORED_LIBS)

    def parse_re_exports(self):
        tbd = self.path / f"Versions/{self.Current}/{self.name}.tbd"
        self.re_exports = None
        if tbd.exists():
            data = yaml.load(tbd.read_text(), Loader=yaml.FullLoader)
            for export in data.get("exports", []):
                self.re_exports = export.get("re-exports")


if __name__ == "__main__":
    if len(sys.argv) >= 2:
        os.chdir(sys.argv[1])

    path = Path("./System/Library")
    if not path.exists():
        print(f"Are you running in sdkroot? Please try: {__file__} <SDKROOT>")
        exit(1)

    for subpath in path.glob("*Frameworks/*.framework"):
        frameworks.append(Framework(subpath))

    print("{ frameworks, libs, objc }:\n")
    print("with frameworks; with libs;")
    print("{")
    for fw in sorted(frameworks, key=lambda x: x.name):
        print(f"{fw.name} = {{")
        print(f'  pname                 = "{fw.name}";')
        print(f'  frameworkPath         = "{fw.path}";')
        if fw.Current:
            print(f'  Current               = "{fw.Current}";')
        if fw.propagatedBuildInputs:
            print(f'  propagatedBuildInputs = [ {" ".join(sorted(fw.propagatedBuildInputs))} ];')
        if fw.re_exports:
            print(f'  reexports             = [ {" ".join(sorted(fw.re_exports))} ];')
        print("};")
    print("}")
