#!/usr/bin/env nix-shell
#! nix-shell -i python -p "python3.withPackages (ps: with ps; [ ps.absl-py ps.requests ])" nix

from collections import defaultdict
import copy
from dataclasses import dataclass
import json
import os.path
import subprocess
from typing import Callable, Dict

from absl import app
from absl import flags
from absl import logging
import requests


FACTORIO_API = "https://factorio.com/api/latest-releases"


FLAGS = flags.FLAGS

flags.DEFINE_string('username', '', 'Factorio username for retrieving binaries.')
flags.DEFINE_string('token', '', 'Factorio token for retrieving binaries.')
flags.DEFINE_string('out', '', 'Output path for versions.json.')


@dataclass
class System:
    nix_name: str
    url_name: str
    tar_name: str


@dataclass
class ReleaseType:
    name: str
    needs_auth: bool = False


@dataclass
class ReleaseChannel:
    name: str


FactorioVersionsJSON = Dict[str, Dict[str, str]]
OurVersionJSON = Dict[str, Dict[str, Dict[str, Dict[str, str]]]]


SYSTEMS = [
    System(nix_name="x86_64-linux", url_name="linux64", tar_name="x64"),
]

RELEASE_TYPES = [
    ReleaseType("alpha", needs_auth=True),
    ReleaseType("demo"),
    ReleaseType("headless"),
]

RELEASE_CHANNELS = [
    ReleaseChannel("experimental"),
    ReleaseChannel("stable"),
]


def find_versions_json() -> str:
    if FLAGS.out:
        return out
    try_paths = ["pkgs/games/factorio/versions.json", "versions.json"]
    for path in try_paths:
        if os.path.exists(path):
            return path
    raise Exception("Couldn't figure out where to write versions.json; try specifying --out")


def fetch_versions() -> FactorioVersionsJSON:
    return json.loads(requests.get("https://factorio.com/api/latest-releases").text)


def generate_our_versions(factorio_versions: FactorioVersionsJSON) -> OurVersionJSON:
    rec_dd = lambda: defaultdict(rec_dd)
    output = rec_dd()
    for system in SYSTEMS:
        for release_type in RELEASE_TYPES:
            for release_channel in RELEASE_CHANNELS:
                version = factorio_versions[release_channel.name][release_type.name]
                this_release = {
                    "name":         f"factorio_{release_type.name}_{system.tar_name}-{version}.tar.xz",
                    "url":          f"https://factorio.com/get-download/{version}/{release_type.name}/{system.url_name}",
                    "version":      version,
                    "needsAuth":    release_type.needs_auth,
                    "tarDirectory": system.tar_name,
                }
                output[system.nix_name][release_type.name][release_channel.name] = this_release
    return output


def iter_version(versions: OurVersionJSON, it: Callable[[str, str, str, Dict[str, str]], Dict[str, str]]) -> OurVersionJSON:
    versions = copy.deepcopy(versions)
    for system_name, system in versions.items():
        for release_type_name, release_type in system.items():
            for release_channel_name, release in release_type.items():
                release_type[release_channel_name] = it(system_name, release_type_name, release_channel_name, dict(release))
    return versions


def merge_versions(old: OurVersionJSON, new: OurVersionJSON) -> OurVersionJSON:
    """Copies already-known hashes from version.json to avoid having to re-fetch."""
    def _merge_version(system_name: str, release_type_name: str, release_channel_name: str, release: Dict[str, str]) -> Dict[str, str]:
        old_system = old.get(system_name, {})
        old_release_type = old_system.get(release_type_name, {})
        old_release = old_release_type.get(release_channel_name, {})
        if not "sha256" in old_release:
            logging.info("%s/%s/%s: not copying sha256 since it's missing", system_name, release_type_name, release_channel_name)
            return release
        if not all(old_release.get(k, None) == release[k] for k in ['name', 'version', 'url']):
            logging.info("%s/%s/%s: not copying sha256 due to mismatch", system_name, release_type_name, release_channel_name)
            return release
        release["sha256"] = old_release["sha256"]
        return release
    return iter_version(new, _merge_version)


def nix_prefetch_url(name: str, url: str, algo: str = 'sha256') -> str:
    cmd = ['nix-prefetch-url', '--type', algo, '--name', name, url]
    logging.info('running %s', cmd)
    out = subprocess.check_output(cmd)
    return out.decode('utf-8').strip()


def fill_in_hash(versions: OurVersionJSON) -> OurVersionJSON:
    """Fill in sha256 hashes for anything missing them."""
    urls_to_hash = {}
    def _fill_in_hash(system_name: str, release_type_name: str, release_channel_name: str, release: Dict[str, str]) -> Dict[str, str]:
        if "sha256" in release:
            logging.info("%s/%s/%s: skipping fetch, sha256 already present", system_name, release_type_name, release_channel_name)
            return release
        url = release["url"]
        if url in urls_to_hash:
            logging.info("%s/%s/%s: found url %s in cache", system_name, release_type_name, release_channel_name, url)
            release["sha256"] = urls_to_hash[url]
            return release
        logging.info("%s/%s/%s: fetching %s", system_name, release_type_name, release_channel_name, url)
        if release["needsAuth"]:
            if not FLAGS.username or not FLAGS.token:
                raise Exception("fetching %s/%s/%s from %s requires --username and --token" % (system_name, release_type_name, release_channel_name, url))
            url += f"?username={FLAGS.username}&token={FLAGS.token}"
        release["sha256"] = nix_prefetch_url(release["name"], url)
        urls_to_hash[url] = release["sha256"]
        return release
    return iter_version(versions, _fill_in_hash)


def main(argv):
    factorio_versions = fetch_versions()
    new_our_versions = generate_our_versions(factorio_versions)
    old_our_versions = None
    our_versions_path = find_versions_json()
    if our_versions_path:
        logging.info('Loading old versions.json from %s', our_versions_path)
        with open(our_versions_path, 'r') as f:
            old_our_versions = json.load(f)
    if old_our_versions:
        logging.info('Merging in old hashes')
        new_our_versions = merge_versions(old_our_versions, new_our_versions)
    logging.info('Fetching necessary tars to get hashes')
    new_our_versions = fill_in_hash(new_our_versions)
    with open(our_versions_path, 'w') as f:
        logging.info('Writing versions.json to %s', our_versions_path)
        json.dump(new_our_versions, f, sort_keys=True, indent=2)
        f.write("\n")

if __name__ == '__main__':
    app.run(main)
