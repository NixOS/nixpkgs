#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3 python3.pkgs.requests python3.pkgs.lxml

from lxml import html
import json
import re
import requests
import subprocess

def nix_prefetch_sha256(name):
    return subprocess.run(['nix-prefetch-url', '--type', 'sha256', 'https://optifine.net/download?f=' + name], capture_output=True, text=True).stdout.strip()

# fetch download page
print('Looking up `https://optifine.net/downloads` for versions.')
sess = requests.session()
page = sess.get('https://optifine.net/downloads')
tree = html.fromstring(page.content)

# parse and extract main jar file names
href = tree.xpath('//tr[@class="downloadLine downloadLineMain"]/td[@class="colMirror"]/a/@href')
prog = re.compile('(OptiFine_)([0-9.]*)(.*)\.jar')
result = [ prog.search(x) for x in href ]

# format name, version and hash for each file
catalogue = {}
for i, r in enumerate(result):
    print('[{}/{}] Cataloguing: {}'.format(i, len(result), r.group(0)) + ' ' * 8, end='\r')
    index = r.group(1).lower() + r.group(2).replace('.', '_')
    version = r.group(2) + r.group(3)
    catalogue[index] = {
        "version": version,
        "sha256": nix_prefetch_sha256(r.group(0))
    }

# latest version should be the first entry
if len(catalogue) > 0:
    catalogue['optifine-latest'] = list(catalogue.values())[0]

print('{} versions catalogued.'.format(len(result)) + ' ' * 32)

# write catalogue to file
print('Writing to versions.json... ', end='')
with open('versions.json', 'w') as f:
    json.dump(catalogue, f, indent=4)
    f.write('\n')
print('done.')
