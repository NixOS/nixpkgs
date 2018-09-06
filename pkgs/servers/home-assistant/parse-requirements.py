#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p "python3.withPackages (ps: with ps; [ aiohttp astral async-timeout attrs certifi jinja2 pyjwt cryptography pip pytz pyyaml requests voluptuous ])"
#
# This script downloads Home Assistant's source tarball.
# Inside the homeassistant/components directory, each component has an associated .py file,
# specifying required packages and other components it depends on:
#
# REQUIREMENTS = [ 'package==1.2.3' ]
# DEPENDENCIES = [ 'component' ]
#
# By parsing the files, a dictionary mapping component to requirements and dependencies is created.
# For all of these requirements and the dependencies' requirements,
# Nixpkgs' python3Packages are searched for appropriate names.
# Then, a Nix attribute set mapping component name to dependencies is created.

from urllib.request import urlopen
import tempfile
from io import BytesIO
import tarfile
import importlib
import subprocess
import os
import sys
import json
import re

COMPONENT_PREFIX = 'homeassistant.components'
PKG_SET = 'python3Packages'

# If some requirements are matched by multiple python packages,
# the following can be used to choose one of them
PKG_PREFERENCES = {
    # Use python3Packages.youtube-dl-light instead of python3Packages.youtube-dl
    'youtube-dl': 'youtube-dl-light'
}

def get_version():
    with open(os.path.dirname(sys.argv[0]) + '/default.nix') as f:
        m = re.search('hassVersion = "([\\d\\.]+)";', f.read())
        return m.group(1)

def parse_components(version='master'):
    components = {}
    with tempfile.TemporaryDirectory() as tmp:
        with urlopen('https://github.com/home-assistant/home-assistant/archive/{}.tar.gz'.format(version)) as response:
            tarfile.open(fileobj=BytesIO(response.read())).extractall(tmp)
        # Use part of a script from the Home Assistant codebase
        sys.path.append(tmp + '/home-assistant-{}'.format(version))
        from script.gen_requirements_all import explore_module
        for package in explore_module(COMPONENT_PREFIX, True):
            # Remove 'homeassistant.components.' prefix
            component = package[len(COMPONENT_PREFIX + '.'):]
            try:
                module = importlib.import_module(package)
                components[component] = {}
                components[component]['requirements'] = getattr(module, 'REQUIREMENTS', [])
                components[component]['dependencies'] = getattr(module, 'DEPENDENCIES', [])
            # If there is an ImportError, the imported file is not the main file of the component
            except ImportError:
                continue
    return components

# Recursively get the requirements of a component and its dependencies
def get_reqs(components, component):
    requirements = set(components[component]['requirements'])
    for dependency in components[component]['dependencies']:
        requirements.update(get_reqs(components, dependency))
    return requirements

# Store a JSON dump of Nixpkgs' python3Packages
output = subprocess.check_output(['nix-env', '-f', os.path.dirname(sys.argv[0]) + '/../../..', '-qa', '-A', PKG_SET, '--json'])
packages = json.loads(output)

def name_to_attr_path(req):
    attr_paths = set()
    names = [req]
    # E.g. python-mpd2 is actually called python3.6-mpd2
    # instead of python-3.6-python-mpd2 inside Nixpkgs
    if req.startswith('python-') or req.startswith('python_'):
        names.append(req[len('python-'):])
    for name in names:
        # treat "-" and "_" equally
        name = re.sub('[-_]', '[-_]', name)
        pattern = re.compile('^python\\d\\.\\d-{}-\\d'.format(name), re.I)
        for attr_path, package in packages.items():
            if pattern.match(package['name']):
                attr_paths.add(attr_path)
    if len(attr_paths) > 1:
        for to_replace, replacement in PKG_PREFERENCES.items():
            try:
                attr_paths.remove(PKG_SET + '.' + to_replace)
                attr_paths.add(PKG_SET + '.' + replacement)
            except KeyError:
                pass
    # Let's hope there's only one derivation with a matching name
    assert(len(attr_paths) <= 1)
    if len(attr_paths) == 1:
        return attr_paths.pop()
    else:
        return None

version = get_version()
print('Generating component-packages.nix for version {}'.format(version))
components = parse_components(version=version)
build_inputs = {}
for component in sorted(components.keys()):
    attr_paths = []
    for req in sorted(get_reqs(components, component)):
        # Some requirements are specified by url, e.g. https://example.org/foobar#xyz==1.0.0
        # Therefore, if there's a "#" in the line, only take the part after it
        req = req[req.find('#') + 1:]
        name = req.split('==')[0]
        attr_path = name_to_attr_path(name)
        if attr_path is not None:
            # Add attribute path without "python3Packages." prefix
            attr_paths.append(attr_path[len(PKG_SET + '.'):])
    else:
        build_inputs[component] = attr_paths

with open(os.path.dirname(sys.argv[0]) + '/component-packages.nix', 'w') as f:
    f.write('# Generated by parse-requirements.py\n')
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
