#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3 nix nix-prefetch-git

import fileinput
import json
import os
import sys
import re
import subprocess

from datetime import datetime
from urllib.request import urlopen, Request


def panic(exc):
    raise Exception(exc)


DIR = os.path.dirname(os.path.abspath(__file__))
HEADERS = {'Accept': 'application/vnd.github.v3+json'}


def github_api_request(endpoint):
    base_url = 'https://api.github.com/'
    request = Request(base_url + endpoint, headers=HEADERS)
    with urlopen(request) as http_response:
        return json.loads(http_response.read().decode('utf-8'))


def get_commit_date(repo, sha):
    url = f'https://api.github.com/repos/{repo}/commits/{sha}'
    request = Request(url, headers=HEADERS)
    with urlopen(request) as http_response:
        commit = json.loads(http_response.read().decode())
        date = commit['commit']['committer']['date'].rstrip('Z')
        date = datetime.fromisoformat(date).date().isoformat()
        return 'unstable-' + date


def nix_prefetch_git(url, rev):
    """Prefetches the requested Git revision (incl. submodules) of the given repository URL."""
    print(f'nix-prefetch-git {url} {rev}')
    out = subprocess.check_output([
        'nix-prefetch-git', '--quiet',
        '--url', url,
        '--rev', rev,
        '--fetch-submodules'])
    return json.loads(out)['sha256']


def nix_prefetch_url(url, unpack=False):
    """Prefetches the content of the given URL."""
    print(f'nix-prefetch-url {url}')
    options = ['--type', 'sha256']
    if unpack:
        options += ['--unpack']
    out = subprocess.check_output(['nix-prefetch-url'] + options + [url])
    return out.decode('utf-8').rstrip()


def update_file(relpath, variant, version, suffix, sha256):
    file_path = os.path.join(DIR, relpath)
    with fileinput.FileInput(file_path, inplace=True) as f:
        for line in f:
            result = line
            result = re.sub(
                fr'^      version = ".+"; #{variant}',
                f'      version = "{version}"; #{variant}',
                result)
            result = re.sub(
                fr'^      suffix = ".+"; #{variant}',
                f'      suffix = "{suffix}"; #{variant}',
                result)
            result = re.sub(
                fr'^      sha256 = ".+"; #{variant}',
                f'      sha256 = "{sha256}"; #{variant}',
                result)
            print(result, end='')


def read_file(relpath, variant):
    file_path = os.path.join(DIR, relpath)
    re_version = re.compile(fr'^\s*version = "(.+)"; #{variant}')
    re_suffix = re.compile(fr'^\s*suffix = "(.+)"; #{variant}')
    version = None
    suffix = None
    with fileinput.FileInput(file_path, mode='r') as f:
        for line in f:
            version_match = re_version.match(line)
            if version_match:
                version = version_match.group(1)
                continue

            suffix_match = re_suffix.match(line)
            if suffix_match:
                suffix = suffix_match.group(1)
                continue

            if version and suffix:
                break
    return version, suffix


if __name__ == "__main__":
    if len(sys.argv) == 1:
        panic("Update variant expected")
    variant = sys.argv[1]
    if variant not in ("zen", "lqx"):
        panic(f"Unexepected variant instead of 'zen' or 'lqx': {sys.argv[1]}")
    pattern = re.compile(fr"v(\d+\.\d+\.?\d*)-({variant}\d+)")
    zen_tags = github_api_request('repos/zen-kernel/zen-kernel/releases')
    for tag in zen_tags:
        zen_match = pattern.match(tag['tag_name'])
        if zen_match:
            zen_tag = zen_match.group(0)
            zen_version = zen_match.group(1)
            zen_suffix = zen_match.group(2)
            break
    old_version, old_suffix = read_file('zen-kernels.nix', variant)
    if old_version != zen_version or old_suffix != zen_suffix:
        zen_hash = nix_prefetch_git('https://github.com/zen-kernel/zen-kernel.git', zen_tag)
        update_file('zen-kernels.nix', variant, zen_version, zen_suffix, zen_hash)
