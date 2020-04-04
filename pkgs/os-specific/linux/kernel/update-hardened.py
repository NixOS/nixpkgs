#! /usr/bin/env nix-shell
#! nix-shell -i python -p "python3.withPackages (ps: [ps.PyGithub])" git gnupg

# This is automatically called by ./update.sh.

import re
import json
import sys
import os.path
from glob import glob
import subprocess
from tempfile import TemporaryDirectory

from github import Github

HERE = os.path.dirname(os.path.realpath(__file__))
HARDENED_GITHUB_REPO = 'anthraxx/linux-hardened'
HARDENED_TRUSTED_KEY = os.path.join(HERE, 'anthraxx.asc')
HARDENED_PATCHES_PATH = os.path.join(HERE, 'hardened-patches.json')
MIN_KERNEL = (4, 14)

HARDENED_VERSION_RE = re.compile(r'''
    (?P<kernel_version> [\d.]+) \.
    (?P<version_suffix> [a-z]+)
''', re.VERBOSE)

def parse_version(version):
    match = HARDENED_VERSION_RE.fullmatch(version)
    if match:
        return match.groups()

def run(*args, **kwargs):
    try:
        return subprocess.run(
            args, **kwargs,
            check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
        )
    except subprocess.CalledProcessError as err:
        print(
            f'error: `{err.cmd}` failed unexpectedly\n'
            f'status code: {err.returncode}\n'
            f'stdout:\n{err.stdout.decode("utf-8").strip()}\n'
            f'stderr:\n{err.stderr.decode("utf-8").strip()}',
            file=sys.stderr,
        )
        sys.exit(1)

def nix_prefetch_url(url):
    output = run('nix-prefetch-url', '--print-path', url).stdout
    return output.decode('utf-8').strip().split('\n')

def verify_openpgp_signature(*, name, trusted_key, sig_path, data_path):
    with TemporaryDirectory(suffix='.nixpkgs-gnupg-home') as gnupg_home:
        run('gpg', '--homedir', gnupg_home, '--import', trusted_key)
        keyring = os.path.join(gnupg_home, 'pubring.kbx')
        try:
            subprocess.run(
                ('gpgv', '--keyring', keyring, sig_path, data_path),
                check=True, stderr=subprocess.PIPE,
            )
            return True
        except subprocess.CalledProcessError as err:
            print(
                f'error: signature for {name} failed to verify!',
                file=sys.stderr,
            )
            print(err.stderr.decode('utf-8'), file=sys.stderr, end='')
            return False

def fetch_patch(*, name, release):
    def find_asset(filename):
        try:
            return next(
                asset.browser_download_url
                for asset in release.get_assets()
                if asset.name == filename
            )
        except StopIteration:
            raise KeyError(filename)

    try:
        patch_url = find_asset(f'{name}.patch')
        sig_url = find_asset(f'{name}.patch.sig')
    except KeyError:
        print(f'error: {name}.patch{{,sig}} not present', file=sys.stderr)
        return None

    sha256, patch_path = nix_prefetch_url(patch_url)
    _, sig_path = nix_prefetch_url(sig_url)
    sig_ok = verify_openpgp_signature(
        name=name,
        trusted_key=HARDENED_TRUSTED_KEY,
        sig_path=sig_path,
        data_path=patch_path,
    )
    if not sig_ok:
        return None

    return {
        'url': patch_url,
        'sha256': sha256,
    }

def commit_patches(*, kernel_version, message):
    with open(HARDENED_PATCHES_PATH + '.new', 'w') as new_patches_file:
        json.dump(patches, new_patches_file, indent=4, sort_keys=True)
        new_patches_file.write('\n')
    os.rename(HARDENED_PATCHES_PATH + '.new', HARDENED_PATCHES_PATH)
    message = f'linux/hardened-patches/{kernel_version}: {message}'
    print(message)
    if os.environ.get('COMMIT'):
        run(
            'git', '-C', HERE, 'commit', f'--message={message}',
            'hardened-patches.json',
        )

# Load the existing patches.
with open(HARDENED_PATCHES_PATH) as patches_file:
    patches = json.load(patches_file)

NIX_VERSION_RE = re.compile(r'''
    \s* version \s* =
    \s* " (?P<version> [^"]*) "
    \s* ; \s* \n
''', re.VERBOSE)

# Get the set of currently packaged kernel versions.
kernel_versions = set()
for filename in os.listdir(HERE):
    filename_match = re.fullmatch(r'linux-(\d+)\.(\d+)\.nix', filename)
    if filename_match:
        if tuple(int(v) for v in filename_match.groups()) < MIN_KERNEL:
            continue
        with open(os.path.join(HERE, filename)) as nix_file:
            for nix_line in nix_file:
                match = NIX_VERSION_RE.fullmatch(nix_line)
                if match:
                    kernel_versions.add(match.group('version'))

# Remove patches for old kernel versions.
for kernel_version in patches.keys() - kernel_versions:
    del patches[kernel_version]
    commit_patches(kernel_version=kernel_version, message='remove')

g = Github(os.environ.get('GITHUB_TOKEN'))
repo = g.get_repo(HARDENED_GITHUB_REPO)
releases = repo.get_releases()

found_kernel_versions = set()
failures = False

for release in releases:
    remaining_kernel_versions = kernel_versions - found_kernel_versions

    if not remaining_kernel_versions:
        break

    version = release.tag_name
    name = f'linux-hardened-{version}'
    version_info = parse_version(version)
    if not version_info:
        continue
    kernel_version, version_suffix = version_info

    if kernel_version in remaining_kernel_versions:
        found_kernel_versions.add(kernel_version)
        try:
            old_version_suffix = patches[kernel_version]['version_suffix']
            old_version = f'{kernel_version}.{old_version_suffix}'
            update = old_version_suffix < version_suffix
        except KeyError:
            update = True
            old_version = None

        if update:
            patch = fetch_patch(name=name, release=release)
            if patch is None:
                failures = True
            else:
                patch['version_suffix'] = version_suffix
                patches[kernel_version] = patch
                if old_version:
                    message = f'{old_version} -> {version}'
                else:
                    message = f'init at {version}'
                commit_patches(kernel_version=kernel_version, message=message)

missing_kernel_versions = kernel_versions - patches.keys()

if missing_kernel_versions:
    print(
        f'warning: no patches for kernel versions ' +
        ', '.join(missing_kernel_versions) +
        '\nwarning: consider manually backporting older patches (bump '
        'JSON key, set version_suffix to "NixOS-a")',
        file=sys.stderr,
    )

if failures:
    sys.exit(1)
