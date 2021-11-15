#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3 git nix

import json
import os
import re
import shlex
import subprocess
import sys
import tempfile
from urllib.parse import urljoin
from urllib.request import urlopen


def run(*args, check=True, **kwargs):
    print('$', *map(shlex.quote, args), file=sys.stderr)
    p = subprocess.run(args, **kwargs)
    if check:
        p.check_returncode()
    return p


def respect_numbers(x):
    parts = re.split(r'(\d+)', x)
    for i, part in enumerate(parts):
        try:
            parts[i] = int(part, 10)
        except ValueError:
            pass
    return tuple(parts)


def get_lastest_link(url):
    with urlopen(url) as r:
        text = r.read()
    i = text.find(b'<pre>') + 5
    j = text.find(b'</pre>', i)
    links = re.findall(r'(?<=href=")(?!\.\./").*?(?=")', text[i:j].decode('ascii'))
    links.sort(key=respect_numbers)
    return urljoin(url, links[-1])


def replace(info, **kwargs):
    attr, value = kwargs.popitem()
    assert not kwargs
    pos = info[attr]['pos']
    with tempfile.NamedTemporaryFile(dir=os.path.dirname(pos['file']), mode='wb') as fout:
        with open(pos['file'], 'rb') as fin:
            for lineno, line in enumerate(fin, 1):
                if lineno == pos['line']:
                    indent = pos['column'] - 1
                    line = ('%s%s = %s;\n' % (' ' * indent, attr, json.dumps(value))).encode('utf-8')
                fout.write(line)
        fout.flush()
        os.rename(fout.name, pos['file'])
        fout._closer.delete = False


info = json.loads(run('nix-instantiate', '--expr', '--strict', '--json', '--eval', '''
with builtins;
mapAttrs (_: attrs:
  mapAttrs (k: v:
    {
      value = v;
      pos = unsafeGetAttrPos k attrs;
    }
  ) attrs
) (
  import ./versions.nix (x: x)
)
''', stdout=subprocess.PIPE, encoding='utf-8').stdout)

for attr, info in info.items():
    if attr == 'latest':
        index_url = get_lastest_link('https://cdn.zabbix.com/zabbix/sources/stable/')
    else:
        m = re.match(r'[^.]*\.[^.]*', info['version']['value'])
        index_url = urljoin('https://cdn.zabbix.com/zabbix/sources/stable/', m[0] + '/')
    url = get_lastest_link(index_url)
    m = re.search(r'(?<=-).*?(?=\.tar\.[^.]*$)', url)
    version = m[0]
    sha256 = run('nix-prefetch-url', '--type', 'sha256', url,
                 stdout=subprocess.PIPE, encoding='utf-8').stdout.strip()

    replace(info, version=version)
    replace(info, sha256=sha256)
    if 'vendorSha256' in info:
        vendorSha256 = '0' * 52
        replace(info, vendorSha256=vendorSha256)
        args = ['nix-build', '--no-out-link',
                '--argstr', 'attr', attr,
                '-E', '{ attr }: with import ../../../.. {}; (zabbixFor attr).agent2.go-modules']
        print('$', *map(shlex.quote, args), file=sys.stderr)
        p = subprocess.Popen(args, stderr=subprocess.PIPE, encoding='utf-8')
        for line in p.stderr:
            sys.stderr.write(line)
            m = re.match(r'^  got:    sha256:(.*)', line)
            if m:
                vendorSha256 = m[1]
        p.wait()
        replace(info, vendorSha256=vendorSha256)

    run('git', 'commit',
        '-m', 'zabbix: %s -> %s' % (info['version']['value'], version),
        'versions.nix', check=False)
