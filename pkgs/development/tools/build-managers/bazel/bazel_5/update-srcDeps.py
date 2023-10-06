#!/usr/bin/env python3
import sys
import json

if len(sys.argv) != 2:
    print("usage: ./this-script src-deps.json < WORKSPACE", file=sys.stderr)
    print("Takes the bazel WORKSPACE file and reads all archives into a json dict (by evaling it as python code)", file=sys.stderr)
    print("Hail Eris.", file=sys.stderr)
    sys.exit(1)

http_archives = []

# just the kw args are the dict { name, sha256, urls … }
def http_archive(**kw):
    http_archives.append(kw)
# like http_file
def http_file(**kw):
    http_archives.append(kw)

# this is inverted from http_archive/http_file and bundles multiple archives
def _distdir_tar(**kw):
    for archive_name in kw['archives']:
        http_archives.append({
            "name": archive_name,
            "sha256": kw['sha256'][archive_name],
            "urls": kw['urls'][archive_name]
        })

# TODO?
def git_repository(**kw):
    print(json.dumps(kw, sort_keys=True, indent=4), file=sys.stderr)
    sys.exit(1)

# execute the WORKSPACE like it was python code in this module,
# using all the function stubs from above.
exec(sys.stdin.read())

# transform to a dict with the names as keys
d = { el['name']: el for el in http_archives }

def has_urls(el):
    return ('url' in el and el['url']) or ('urls' in el and el['urls'])
def has_sha256(el):
    return 'sha256' in el and el['sha256']
bad_archives = list(filter(lambda el: not has_urls(el) or not has_sha256(el), d.values()))
if bad_archives:
    print('Following bazel dependencies are missing url or sha256', file=sys.stderr)
    print('Check bazel sources for master or non-checksummed dependencies', file=sys.stderr)
    for el in bad_archives:
        print(json.dumps(el, sort_keys=True, indent=4), file=sys.stderr)
    sys.exit(1)

with open(sys.argv[1], "w") as f:
    print(json.dumps(d, sort_keys=True, indent=4), file=f)
