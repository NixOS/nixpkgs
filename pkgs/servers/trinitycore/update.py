#!/usr/bin/env nix-shell
#!nix-shell -p nix-prefetch-git -p jq -p "python3.withPackages (ps: [ ps.pygithub ])" -i python3
from subprocess import run, PIPE, check_output
from github import Github, GitRelease, GitTag
import fileinput
import re
from dataclasses import dataclass
import os
import sys

@dataclass
class TDB:
    url: str
    name: str
    tarball_hash: str

@dataclass
class TCRelease:
    tarball_url: str
    commit: str
    version: str
    branch: str

    def is_compatible_with(self, other_branch: str) -> bool:
        return self.branch == other_branch

    @property
    def tarball_hash(self) -> str:
        return nix_prefetch_url(self.tarball_url)


supported_branches = ("335", "434", "master")

branches_override = {
    "434": {
        "owner": "The-Cataclysm-Preservation-Project"
    },
    "master": {
        "wow_branch": "1017"
    }
}

def nix_prefetch_url(url: str, algo: str = 'sha256') -> str:
    print(f'nix-prefetch-url {url}')
    out = check_output(['nix-prefetch-url', '--type', algo, '--unpack', url])
    out = out.decode('utf-8').rstrip()
    sri = check_output(["nix", "hash", "to-sri", f"{algo}:{out}"])
    return sri.decode('utf-8').rstrip()

def parse_tdb_title(title: str):
    """
    >>> parse_tdb_title("TDB 335.62")
    335
    >>> parse_tdb_title("TDB 1015.23071")
    1015
    >>> parse_tdb_title("TDB335.78")
    335
    """
    return title.lower().lstrip("tdb").split(".")[0]

def parse_tc_release(release: GitRelease, tags: list[GitTag]) -> TCRelease:
    tag = next((t for t in tags if t.name == release.tag_name))

    return TCRelease(
        tarball_url=release.tarball_url,
        commit=tag.commit.sha,
        version=release.tag_name,
        branch=parse_tdb_title(release.title)
    )

def update_branch(github: Github, branch_version: str):
    # 1. get all releases
    branch_override = branches_override.get(branch_version, {})
    wow_branch = branch_override.get("wow_branch", branch_version)
    branch_filename = branch_override.get("branch_filename", f"{branch_version}.nix")
    owner = branch_override.get("owner", "TrinityCore")
    repo_name = branch_override.get("repo", "TrinityCore")
    repo = github.get_repo(f"{owner}/{repo_name}")
    last_release = [rl for rl in repo.get_releases() if rl.title.startswith(f'TDB {wow_branch}')][0]
    last_tags = list(repo.get_tags())
    # 2. parse all TDB releases and filter them
    tc_release = parse_tc_release(last_release, last_tags)
    # 3. update this current branch with this release
    print(f'updating to {tc_release.version}')
    tarball_hash = tc_release.tarball_hash
    with fileinput.FileInput(branch_filename, inplace=True) as file:
        for line in file:
            result = re.sub(r'^  version = ".+";', f'  version = "{tc_release.version}";', line)
            result = re.sub(r'^  commit = ".+";', f'  commit = "{tc_release.commit}";', result)
            result = re.sub(r'^  hash = ".+";', f'  hash = "{tarball_hash}";', result)
            print(result, end='')

def main():
    login_or_token = None
    selected_branch = sys.argv[1] if len(sys.argv) >= 2 else None
    if (token := os.environ.get('GITHUB_TOKEN')) is not None:
        login_or_token = token
    github = Github(login_or_token=login_or_token)

    if selected_branch is None:
        for branch in supported_branches:
            print(f'updating {branch}')
            update_branch(github, branch)
    else:
        print(f'updating {selected_branch}')
        update_branch(github, selected_branch)

if __name__ == '__main__':
    main()
