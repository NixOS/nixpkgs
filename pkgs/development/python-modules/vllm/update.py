#!/usr/bin/env nix-shell
#! nix-shell -i python3 -p python3 python3Packages.sh sd ripgrep nix-prefetch common-updater-scripts

"""
Updates the main vLLM package and three external dependencies.
"""

import json
import os
from pathlib import Path
from urllib.request import Request, urlopen
import sh


CONFIGS = {
    'NVIDIA/cutlass': {
        'upstream_file': 'CMakeLists.txt',
        'upstream_pattern': r'CUTLASS_REVISION "([^"]+)"',
        'nix_search_pattern': r'cutlass = fetchFromGitHub',
        'field': 'tag',
        'current_pattern': r'cutlass = fetchFromGitHub.*?tag = "([^"]+)"',
        'update_pattern': r'(cutlass = fetchFromGitHub.*?tag = ")[^"]+(";.*?hash = ")[^"]+(";)',
    },
    'vllm-project/FlashMLA': {
        'upstream_file': 'cmake/external_projects/flashmla.cmake',
        'upstream_pattern': r'GIT_TAG ([a-f0-9]+)',
        'nix_search_pattern': r'flashmla = stdenv\.mkDerivation',
        'field': 'rev',
        'current_pattern': r'flashmla = stdenv\.mkDerivation.*?rev = "([^"]+)"',
        'update_pattern': r'(flashmla = stdenv\.mkDerivation.*?rev = ")[^"]+(";.*?hash = ")[^"]+(";)',
        'version_config': {
            'source_file': 'setup.py',
            'version_pattern': r'"([0-9]+\.[0-9]+\.[0-9]+)"',
            'version_update_pattern': r'(flashmla = stdenv\.mkDerivation.*?version = ")[^"]+(";)',
        },
    },
    'vllm-project/flash-attention': {
        'upstream_file': 'cmake/external_projects/vllm_flash_attn.cmake',
        'upstream_pattern': r'GIT_TAG ([a-f0-9]+)',
        'nix_search_pattern': r"vllm-flash-attn' = lib\.defaultTo",
        'field': 'rev',
        'current_pattern': r"vllm-flash-attn' = lib\.defaultTo.*?rev = \"([^\"]+)\"",
        'update_pattern': r"(vllm-flash-attn' = lib\.defaultTo.*?rev = \")[^\"]+(\";.*?hash = \")[^\"]+(\";)",
        'version_config': {
            'source_file': 'vllm_flash_attn/__init__.py',
            'version_pattern': r'__version__\s*=\s*"([^"]+)"',
            'version_update_pattern': r"(vllm-flash-attn' = lib\.defaultTo.*?version = \")[^\"]+(\";)",
        },
    },
}


def update_version_string(github_repo: str, new_revision: str, vllm_project_base_url: str, headers: dict, nix_file: str) -> None:
    """Update hardcoded version strings in the Nix file by parsing source files."""
    config = CONFIGS.get(github_repo)
    if not config:
        return

    version_config = config.get('version_config')
    if not version_config:
        return

    repo_name = github_repo.split('/')[-1]
    source_url = f"{vllm_project_base_url}/{repo_name}/{new_revision}/{version_config['source_file']}"
    with urlopen(Request(source_url, headers=headers)) as response:
        version = sh.rg('--only-matching', '--color', 'never', version_config['version_pattern'], '--replace', '$1', _in=response.read().decode('utf-8')).strip()

    if version:
        replacement = f'${{1}}{version}${{2}}'
        sh.sd('--flags', 'ms', version_config['version_update_pattern'], replacement, nix_file)


def update_git_dep(repo: str, config: dict, versioned_vllm_url: str, vllm_project_base_url: str, headers: dict, nix_file: str) -> None:
    """Update a git dependency by parsing CMake external project configurations."""
    # Extract new revision from upstream
    upstream_url = f'{versioned_vllm_url}/{config["upstream_file"]}'
    with urlopen(Request(upstream_url, headers=headers)) as response:
        upstream_content = response.read().decode('utf-8')
        new_revision = sh.rg('--only-matching', '--color', 'never', config['upstream_pattern'], '--replace', '$1', _in=upstream_content).strip()

    current_revision = sh.rg('--multiline', '--multiline-dotall', '--only-matching', '--color', 'never',
                          config['current_pattern'], '--replace', '$1', _in=Path(nix_file).read_text()).strip()

    if current_revision == new_revision:
        return

    # Update revision and hash
    archive_url = f'https://github.com/{repo}/archive/{new_revision}.tar.gz'
    unpacked_hash = sh.nix_prefetch_url('--unpack', archive_url).strip()
    sri_hash = sh.nix('hash', 'convert', '--hash-algo', 'sha256', unpacked_hash).strip()

    replacement = f'${{1}}{new_revision}${{2}}{sri_hash}${{3}}'
    sh.sd('--flags', 'ms', config['update_pattern'], replacement, nix_file)

    # Update version strings if needed
    update_version_string(repo, new_revision, vllm_project_base_url, headers, nix_file)


def main():
    github_token = os.environ.get('GITHUB_TOKEN')
    if not github_token:
        print("Warning: No GITHUB_TOKEN set - may hit GitHub API rate limits")

    headers = {'Accept': 'application/vnd.github.v3+json'}
    if github_token:
        headers['Authorization'] = f'bearer {github_token}'

    nix_file = str(Path(__file__).resolve().parent / 'default.nix')

    # Fetch latest vLLM release version
    with urlopen(Request('https://api.github.com/repos/vllm-project/vllm/releases/latest', headers=headers)) as response:
        vllm_version = json.loads(response.read())['tag_name'].lstrip('v')

    # Base URLs
    vllm_project_base_url = 'https://raw.githubusercontent.com/vllm-project'
    versioned_vllm_url = f'{vllm_project_base_url}/vllm/v{vllm_version}'

    # Update main package
    sh.update_source_version('python3Packages.vllm', vllm_version)

    # Update dependencies
    for repo, config in CONFIGS.items():
        update_git_dep(repo, config, versioned_vllm_url, vllm_project_base_url, headers, nix_file)


if __name__ == '__main__':
    main()
