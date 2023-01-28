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
