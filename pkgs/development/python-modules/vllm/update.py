#!/usr/bin/env nix-shell
#! nix-shell -i python3 -p python3 python3Packages.sh sd nix-prefetch-github common-updater-scripts

"""
Updates the main vLLM package and three external dependencies.
"""

import argparse
import json
import os
import re
from pathlib import Path
from urllib.request import Request, urlopen
import sh


API_BASE = 'https://api.github.com/repos'
RAW_BASE = 'https://raw.githubusercontent.com'

NIX_FILE = str(Path(__file__).resolve().parent / 'default.nix')
GITHUB_TOKEN = os.environ.get('GITHUB_TOKEN', '')
HEADERS = {'Accept': 'application/vnd.github.v3+json'} | (
    {'Authorization': f'bearer {GITHUB_TOKEN}'} if GITHUB_TOKEN else {}
)

PKG_NAME = 'python3Packages.vllm'
PKG_REPO = 'vllm-project/vllm'
TAG_PATTERN = r'(repo = "vllm";\s+)tag = "v\$\{version\}";'
REV_PATTERN = r'(repo = "vllm";\s+)rev = "[a-f0-9]{40}";'

DEPENDENCIES = {
    'NVIDIA/cutlass': {
        'upstream_file': 'CMakeLists.txt',
        'upstream_pattern': r'CUTLASS_REVISION "([^"]+)"',
        'update_pattern': r'(cutlass = fetchFromGitHub.*?tag = ")[^"]+(";.*?hash = ")[^"]+(";)',
    },
    'vllm-project/FlashMLA': {
        'upstream_file': 'cmake/external_projects/flashmla.cmake',
        'upstream_pattern': r'GIT_TAG ([a-f0-9]+)',
        'update_pattern': r'(flashmla = stdenv\.mkDerivation.*?rev = ")[^"]+(";.*?hash = ")[^"]+(";)',
        'version_config': {
            'source_file': 'setup.py',
            'version_pattern': r'"([0-9]+\.[0-9]+\.[0-9]+)"',
            'update_pattern': r'(flashmla = stdenv\.mkDerivation.*?version = ")[^"]+(";)',
        },
    },
    'vllm-project/flash-attention': {
        'upstream_file': 'cmake/external_projects/vllm_flash_attn.cmake',
        'upstream_pattern': r'GIT_TAG ([a-f0-9]+)',
        'update_pattern': r"(vllm-flash-attn' = lib\.defaultTo.*?rev = \")[^\"]+(\";.*?hash = \")[^\"]+(\";)",
        'version_config': {
            'source_file': 'vllm_flash_attn/__init__.py',
            'version_pattern': r'__version__\s*=\s*"([^"]+)"',
            'update_pattern': r"(vllm-flash-attn' = lib\.defaultTo.*?version = \")[^\"]+(\";)",
        },
    },
}


def fetch_json(url: str) -> dict:
    with urlopen(Request(url, headers=HEADERS)) as r:
        return json.loads(r.read())

def fetch_text(url: str) -> str:
    with urlopen(Request(url, headers=HEADERS)) as r:
        return r.read().decode('utf-8')


def update_git_dep(github_repo: str, config: dict, pkg_ref: str) -> None:
    upstream_url = f'{RAW_BASE}/{PKG_REPO}/{pkg_ref}/{config["upstream_file"]}'
    new_revision = re.search(config['upstream_pattern'], fetch_text(upstream_url)).group(1)
    sri_hash = json.loads(sh.nix_prefetch_github(*github_repo.split('/'), '--rev', new_revision).strip())['hash']
    sh.sd('--flags', 'ms', config['update_pattern'], rf'${{1}}{new_revision}${{2}}{sri_hash}${{3}}', NIX_FILE)
    if version_config := config.get('version_config'):
        source_url = f'{RAW_BASE}/{github_repo}/{new_revision}/{version_config["source_file"]}'
        version = re.search(version_config['version_pattern'], fetch_text(source_url)).group(1)
        sh.sd('--flags', 'ms', version_config['update_pattern'], rf'${{1}}{version}${{2}}', NIX_FILE)


def update_primary_package(mode: str) -> str:
    release_data = fetch_json(f'{API_BASE}/{PKG_REPO}/releases/latest')
    main_data = fetch_json(f'{API_BASE}/{PKG_REPO}/commits/main')
    rc_data = next(tag for tag in fetch_json(f'{API_BASE}/{PKG_REPO}/tags') if 'rc' in tag['name'])
    rc_version = rc_data['name'].lstrip('v')
    dev_commit_count = fetch_json(f'{API_BASE}/{PKG_REPO}/compare/{rc_data['name']}...{main_data['sha']}')['ahead_by']
    stable_version = release_data['tag_name'].lstrip('v')

    match mode:
        case "dev":
            version, ref = f"{rc_version}.dev{dev_commit_count}", 'main'
            sh.sd('--flags', 'ms', TAG_PATTERN, rf'${{1}}rev = "{main_data["sha"]}";', NIX_FILE)
        case "rc":
            version, ref = rc_version, rc_data['name']
        case _:
            version, ref = stable_version, release_data['tag_name']

    if mode != "dev":
        sh.sd('--flags', 'ms', REV_PATTERN, r'${1}tag = "v$${version}";', NIX_FILE)

    sh.update_source_version(PKG_NAME, version, '--ignore-same-version')
    return ref


def main():
    parser = argparse.ArgumentParser(description='Update vLLM package and dependencies')
    group = parser.add_mutually_exclusive_group()
    group.add_argument('--dev', action='store_true', help='Update to main branch dev version')
    group.add_argument('--rc', action='store_true', help='Update to latest release candidate')
    args = parser.parse_args()
    if not GITHUB_TOKEN:
        print("Warning: No GITHUB_TOKEN set - may hit GitHub API rate limits")
    mode = "dev" if args.dev else "rc" if args.rc else "stable"
    pkg_ref = update_primary_package(mode)
    for repo, config in DEPENDENCIES.items():
        update_git_dep(repo, config, pkg_ref)


if __name__ == '__main__':
    main()
