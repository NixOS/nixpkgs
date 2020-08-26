#!/usr/bin/env python
# Patch out path dependencies from a pyproject.json file

import json
import sys

data = json.load(sys.stdin)


def get_deep(o, path):
    for p in path.split('.'):
        o = o.get(p, {})
    return o


for dep in get_deep(data, 'tool.poetry.dependencies').values():
    if isinstance(dep, dict):
        try:
            del dep['path'];
        except KeyError:
            pass
        else:
            dep['version'] = '*'

json.dump(data, sys.stdout, indent=4)
