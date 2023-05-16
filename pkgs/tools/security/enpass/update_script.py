<<<<<<< HEAD
#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3 python3.pkgs.packaging python3.pkgs.requests
import gzip
import json
import logging
import pathlib
import re
import subprocess
import sys

from packaging import version
import requests

logging.basicConfig(stream=sys.stdout, level=logging.DEBUG)

current_path = pathlib.Path(__file__).parent
DATA_JSON = current_path.joinpath("data.json").resolve()
logging.debug(f"Path to version file: {DATA_JSON}")
last_new_version = None

with open(DATA_JSON, "r") as versions_file:
    versions = json.load(versions_file)

def find_latest_version(arch):
    CHECK_URL = f'https://apt.enpass.io/dists/stable/main/binary-{arch}/Packages.gz'
    packages = gzip.decompress(requests.get(CHECK_URL).content).decode()

    # Loop every package to find the newest one!
    version_selector = re.compile("Version: (?P<version>.+)")
    path_selector = re.compile("Filename: (?P<path>.+)")
    hash_selector = re.compile("SHA256: (?P<sha256>.+)")
    last_version = version.parse("0")
    for package in packages.split("\n\n"):
        matches = version_selector.search(package)
        matched_version = matches.group('version') if matches and matches.group('version') else "0"
        parsed_version = version.parse(matched_version)
        if parsed_version > last_version:
            path = path_selector.search(package).group('path')
            sha256 = hash_selector.search(package).group('sha256')
            last_version = parsed_version
            return {"path": path, "sha256": sha256, "version": matched_version}

for arch in versions.keys():
    current_version = versions[arch]['version']
    logging.info(f"Current Version for {arch} is {current_version}")
    new_version = find_latest_version(arch)

    if not new_version or new_version['version'] == current_version:
        continue

    last_current_version = current_version
    last_new_version = new_version
    logging.info(f"Update found ({arch}): enpass: {current_version} -> {new_version['version']}")
    versions[arch]['path'] = new_version['path']
    versions[arch]['sha256'] = new_version['sha256']
    versions[arch]['version'] = new_version['version']


if not last_new_version:
    logging.info('#### No update found ####')
    sys.exit(0)

# write new versions back
with open(DATA_JSON, "w") as versions_file:
    json.dump(versions, versions_file, indent=2)
    versions_file.write("\n")

# Commit the result:
logging.info("Committing changes...")
commit_message = f"enpass: {last_current_version} -> {last_new_version['version']}"
subprocess.run(['git', 'add', DATA_JSON], check=True)
subprocess.run(['git', 'commit', '--file=-'], input=commit_message.encode(), check=True)

logging.info("Done.")
=======
from __future__ import print_function


import argparse
import bz2
import email
import json
import logging

from itertools import product
from operator import itemgetter

import attr
import pkg_resources

from pathlib2 import Path
from requests import Session
from six.moves.urllib_parse import urljoin


@attr.s
class ReleaseElement(object):
    sha256 = attr.ib(repr=False)
    size = attr.ib(convert=int)
    path = attr.ib()

log = logging.getLogger('enpass.updater')


parser = argparse.ArgumentParser()
parser.add_argument('--repo')
parser.add_argument('--target', type=Path)


session = Session()


def parse_bz2_msg(msg):
    msg = bz2.decompress(msg)
    if '\n\n' in msg:
        parts = msg.split('\n\n')
        return list(map(email.message_from_string, parts))
    return email.message_from_string(msg)


def fetch_meta(repo, name, parse=email.message_from_string, split=False):
    url = urljoin(repo, 'dists/stable', name)
    response = session.get("{repo}/dists/stable/{name}".format(**locals()))
    return parse(response.content)


def fetch_filehashes(repo, path):
    meta = fetch_meta(repo, path, parse=parse_bz2_msg)
    for item in meta:
        yield {
            'version': pkg_resources.parse_version(str(item['Version'])),
            'path': item['Filename'],
            'sha256': item['sha256'],
        }


def fetch_archs(repo):
    m = fetch_meta(repo, 'Release')

    architectures = m['Architectures'].split()
    elements = [ReleaseElement(*x.split()) for x in m['SHA256'].splitlines()]
    elements = [x for x in elements if x.path.endswith('bz2')]

    for arch, elem in product(architectures, elements):
        if arch in elem.path:
            yield arch, max(fetch_filehashes(repo, elem.path),
                            key=itemgetter('version'))


class OurVersionEncoder(json.JSONEncoder):
    def default(self, obj):
        # the other way around to avoid issues with
        # newer setuptools having strict/legacy versions
        if not isinstance(obj, (dict, str)):
            return str(obj)
        return json.JSONEncoder.default(self, obj)


def main(repo, target):
    logging.basicConfig(level=logging.DEBUG)
    with target.open(mode='wb') as fp:
        json.dump(
            dict(fetch_archs(repo)), fp,
            cls=OurVersionEncoder,
            indent=2,
            sort_keys=True)


opts = parser.parse_args()
main(opts.repo, opts.target)
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
