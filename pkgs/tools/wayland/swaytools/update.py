#!/usr/bin/env nix-shell
#!nix-shell -i python -p python39Packages.requests python39Packages.pip python39Packages.packaging

import requests
import json
import subprocess
try:
    from packaging.version import parse
except ImportError:
    from pip._vendor.packaging.version import parse


URL_PATTERN = 'https://pypi.python.org/pypi/{package}/json'

def findLine(key,derivation):
    count = 0
    lines = []
    for line in derivation:
        if key in line:
            lines.append(count)
        count += 1
    return lines

def get_version(package, url_pattern=URL_PATTERN):
    """Return version of package on pypi.python.org using json."""
    req = requests.get(url_pattern.format(package=package))
    version = parse('0')
    if req.status_code == requests.codes.ok:
        j = json.loads(req.text.encode(req.encoding))
        releases = j.get('releases', [])
        for release in releases:
            ver = parse(release)
            if not ver.is_prerelease:
                if ver > version:
                    version = ver
                    sha256  = j["releases"][release][-1]["digests"]["sha256"]
    return version, sha256


if __name__ == '__main__':

    nixpkgs         = subprocess.check_output(["git", "rev-parse", "--show-toplevel"]).decode("utf-8").strip('\n')
    swaytoolsFolder = "/pkgs/tools/wayland/swaytools/"
    with open(nixpkgs + swaytoolsFolder + "default.nix", 'r') as arq:
        derivation = arq.readlines()

    version, sha256 = get_version('swaytools')

    key = "version = "
    line = findLine(key,derivation)[0]
    derivation[line] = f'  version = "{version}";\n'

    key = "sha256 = "
    line = findLine(key,derivation)[0]
    derivation[line] = f'    sha256 = "{sha256}";\n'

    with open(nixpkgs + swaytoolsFolder + "default.nix", 'w') as arq:
        arq.writelines(derivation)
