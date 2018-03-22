#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p "python3.withPackages (ps: with ps; [ setuptools ])"
#
# This script downloads https://github.com/home-assistant/home-assistant/blob/master/requirements_all.txt.
# This file contains lines of the form
#
#     # homeassistant.components.foo
#     # homeassistant.components.bar
#     foobar==1.2.3
#
# i.e. it lists dependencies and the components that require them.
# By parsing the file, a dictionary mapping component to dependencies is created.
# For all of these dependencies, Nixpkgs' python3Packages are searched for appropriate names.
# Then, a Nix attribute set mapping component name to dependencies is created.

from urllib.request import urlopen
from collections import OrderedDict
import subprocess
import os
import sys
import json
import re
from pkg_resources import Requirement, RequirementParseError

PREFIX = '# homeassistant.components.'
PKG_SET = 'python3Packages'

def get_version():
    with open(os.path.dirname(sys.argv[0]) + '/default.nix') as f:
        m = re.search('hassVersion = "([\\d\\.]+)";', f.read())
        return m.group(1)

def fetch_reqs(version='master'):
    requirements = {}
    with urlopen('https://github.com/home-assistant/home-assistant/raw/{}/requirements_all.txt'.format(version)) as response:
        components = []
        for line in response.read().decode().splitlines():
            if line == '':
                components = []
            elif line[:len(PREFIX)] == PREFIX:
                component = line[len(PREFIX):]
                components.append(component)
                if component not in requirements:
                    requirements[component] = []
            elif line[0] != '#':
                for component in components:
                    requirements[component].append(line)
    return requirements

# Store a JSON dump of Nixpkgs' python3Packages
output = subprocess.check_output(['nix-env', '-f', os.path.dirname(sys.argv[0]) + '/../../..', '-qa', '-A', PKG_SET, '--json'])
packages = json.loads(output)

def name_to_attr_path(req):
    attr_paths = []
    names = [req]
    # E.g. python-mpd2 is actually called python3.6-mpd2
    # instead of python-3.6-python-mpd2 inside Nixpkgs
    if req.startswith('python-'):
        names.append(req[len('python-'):])
    for name in names:
        pattern = re.compile('^python\\d\\.\\d-{}-\\d'.format(name), re.I)
        for attr_path, package in packages.items():
            if pattern.match(package['name']):
                attr_paths.append(attr_path)
    # Let's hope there's only one derivation with a matching name
    assert(len(attr_paths) <= 1)
    if attr_paths:
        return attr_paths[0]
    else:
        return None

version = get_version()
print('Generating component-packages.nix for version {}'.format(version))
requirements = fetch_reqs(version=version)
build_inputs = {}
for component, reqs in OrderedDict(sorted(requirements.items())).items():
    attr_paths = []
    for req in reqs:
        try:
            name = Requirement.parse(req).project_name
            attr_path = name_to_attr_path(name)
            if attr_path is not None:
                # Add attribute path without "python3Packages." prefix
                attr_paths.append(attr_path[len(PKG_SET + '.'):])
        except RequirementParseError:
            continue
    else:
        build_inputs[component] = attr_paths

# Only select components which have any dependency
#build_inputs = {k: v for k, v in build_inputs.items() if len(v) > 0}

with open(os.path.dirname(sys.argv[0]) + '/component-packages.nix', 'w') as f:
    f.write('# Generated from parse-requirements.py\n')
    f.write('# Do not edit!\n\n')
    f.write('{\n')
    f.write('  version = "{}";\n'.format(version))
    f.write('  components = {\n')
    for component, attr_paths in build_inputs.items():
        f.write('    "{}" = ps: with ps; [ '.format(component))
        f.write(' '.join(attr_paths))
        f.write(' ];\n')
    f.write('  };\n')
    f.write('}\n')
