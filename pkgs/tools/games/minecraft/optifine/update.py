#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i python3 -p python3.pkgs.requests python3.pkgs.lxml nix

from lxml import html
import json
import os.path
import re
import requests
import subprocess

def nix_prefetch_sha256(name):
    return subprocess.run(['nix-prefetch-url', '--type', 'sha256', 'https://optifine.net/download?f=' + name], capture_output=True, text=True).stdout.strip()

# fetch download page
sess = requests.session()
page = sess.get('https://optifine.net/downloads')
tree = html.fromstring(page.content)

# parse and extract main jar file names
href = tree.xpath('//tr[@class="downloadLine downloadLineMain"]/td[@class="colMirror"]/a/@href')
expr = re.compile('(OptiFine_)([0-9.]*)(.*)\.jar')
result = [ expr.search(x) for x in href ]

# format name, version and hash for each file
catalogue = {}
for i, r in enumerate(result):
    index = r.group(1).lower() + r.group(2).replace('.', '_')
    version = r.group(2) + r.group(3)
    catalogue[index] = {
        "version": version,
        "sha256": nix_prefetch_sha256(r.group(0))
    }

# latest version should be the first entry
if len(catalogue) > 0:
    catalogue['optifine-latest'] = list(catalogue.values())[0]

# read previous versions
d = os.path.dirname(os.path.abspath(__file__))
with open(os.path.join(d, 'versions.json'), 'r') as f:
    prev = json.load(f)

# `maintainers/scripts/update.py` will extract stdout to write commit message
# embed the commit message in json and print it
changes = [ { 'commitMessage': 'optifinePackages: update versions\n\n' } ]

# build a longest common subsequence, natural sorted by keys
for key, value in sorted({**prev, **catalogue}.items(), key=lambda item: [int(s) if s.isdigit() else s for s in re.split(r'(\d+)', item[0])]):
    if key not in prev:
        changes[0]['commitMessage'] += 'optifinePackages.{}: init at {}\n'.format(key, value['version'])
    elif value['version'] != prev[key]['version']:
        changes[0]['commitMessage'] += 'optifinePackages.{}: {} -> {}\n'.format(key, prev[key]['version'], value['version'])

# print the changes in stdout
print(json.dumps(changes))

# write catalogue to file
with open(os.path.join(d, 'versions.json'), 'w') as f:
    json.dump(catalogue, f, indent=4)
    f.write('\n')
