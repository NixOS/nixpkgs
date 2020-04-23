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
MIN_KERNEL_VERSION = [4, 14]

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

    patch_filename = f'{name}.patch'
    try:
        patch_url = find_asset(patch_filename)
        sig_url = find_asset(patch_filename + '.sig')
    except KeyError:
        print(f'error: {patch_filename}{{,.sig}} not present', file=sys.stderr)
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
        'name': patch_filename,
        'url': patch_url,
        'sha256': sha256,
    }

def parse_version(version_str):
    version = []
    for component in version_str.split('.'):
        try:
            version.append(int(component))
        except ValueError:
            version.append(component)
    return version

def version_string(version):
    return '.'.join(str(component) for component in version)

def major_kernel_version_key(kernel_version):
    return version_string(kernel_version[:-1])

def commit_patches(*, kernel_key, message):
    with open(HARDENED_PATCHES_PATH + '.new', 'w') as new_patches_file:
        json.dump(patches, new_patches_file, indent=4, sort_keys=True)
        new_patches_file.write('\n')
    os.rename(HARDENED_PATCHES_PATH + '.new', HARDENED_PATCHES_PATH)
    message = f'linux/hardened-patches/{kernel_key}: {message}'
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
kernel_versions = {}
for filename in os.listdir(HERE):
    filename_match = re.fullmatch(r'linux-(\d+)\.(\d+)\.nix', filename)
    if filename_match:
        with open(os.path.join(HERE, filename)) as nix_file:
            for nix_line in nix_file:
                match = NIX_VERSION_RE.fullmatch(nix_line)
                if match:
                    kernel_version = parse_version(match.group('version'))
                    if kernel_version < MIN_KERNEL_VERSION:
                        continue
                    kernel_key = major_kernel_version_key(kernel_version)
                    kernel_versions[kernel_key] = kernel_version

# Remove patches for unpackaged kernel versions.
for kernel_key in sorted(patches.keys() - kernel_versions.keys()):
    commit_patches(kernel_key=kernel_key, message='remove')

g = Github(os.environ.get('GITHUB_TOKEN'))
repo = g.get_repo(HARDENED_GITHUB_REPO)

failures = False

# Match each kernel version with the best patch version.
releases = {}
for release in repo.get_releases():
    version = parse_version(release.tag_name)
    # needs to look like e.g. 5.6.3.a
    if len(version) < 4:
        continue

    kernel_version = version[:-1]
    kernel_key = major_kernel_version_key(kernel_version)
    try:
        packaged_kernel_version = kernel_versions[kernel_key]
    except KeyError:
        continue

    release_info = {
        'version': version,
        'release': release,
    }

    if kernel_version == packaged_kernel_version:
        releases[kernel_key] = release_info
    else:
        # Fall back to the latest patch for this major kernel version,
        # skipping patches for kernels newer than the packaged one.
        if kernel_version > packaged_kernel_version:
            continue
        elif (kernel_key not in releases or
                releases[kernel_key]['version'] < version):
            releases[kernel_key] = release_info

# Update hardened-patches.json for each release.
for kernel_key, release_info in releases.items():
    release = release_info['release']
    version = release_info['version']
    version_str = release.tag_name
    name = f'linux-hardened-{version_str}'

    try:
        old_filename = patches[kernel_key]['name']
        old_version_str = (old_filename
            .replace('linux-hardened-', '')
            .replace('.patch', ''))
        old_version = parse_version(old_version_str)
        update = old_version < version
    except KeyError:
        update = True
        old_version = None

    if update:
        patch = fetch_patch(name=name, release=release)
        if patch is None:
            failures = True
        else:
            patches[kernel_key] = patch
            if old_version:
                message = f'{old_version_str} -> {version_str}'
            else:
                message = f'init at {version_str}'
            commit_patches(kernel_key=kernel_key, message=message)

missing_kernel_versions = kernel_versions.keys() - patches.keys()

if missing_kernel_versions:
    print(
        f'warning: no patches for kernel versions ' +
        ', '.join(missing_kernel_versions),
        file=sys.stderr,
    )

if failures:
    sys.exit(1)
