#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3 python3Packages.gitpython python3Packages.packaging git nix

import git
import json
import os
import packaging.version
import re
import subprocess
import sys
import tempfile

_QUERY_VERSION_PATTERN = re.compile('^([A-Z]+)="(.+)"$')


def query_version(repo: git.Repo):
    # This only works on FreeBSD 13 and later
    text = (
        subprocess.check_output(
            ["bash", os.path.join(repo.working_dir, "sys", "conf", "newvers.sh"), "-v"]
        )
        .decode("utf-8")
        .strip()
    )
    fields = dict()
    for line in text.splitlines():
        m = _QUERY_VERSION_PATTERN.match(line)
        if m is None:
            continue
        fields[m[1].lower()] = m[2]

    fields["major"] = packaging.version.parse(fields["revision"]).major
    return fields


def handle_commit(
    repo: git.Repo, rev: git.objects.commit.Commit, ref_name: str, ref_type: str
):
    repo.git.checkout(rev)
    print(f"{ref_name}: checked out {rev.hexsha}")

    full_hash = (
        subprocess.check_output(["nix", "hash", "path", "--sri", repo.working_dir])
        .decode("utf-8")
        .strip()
    )
    print(f"{ref_name}: hash is {full_hash}")

    version = query_version(repo)
    print(f"{ref_name}: {version['version']}")
    return {
        "rev": rev.hexsha,
        "hash": full_hash,
        "ref": ref_name,
        "ref_type": ref_type,
        "version": query_version(repo),
    }


BASE_DIR = os.path.dirname(os.path.abspath(__file__))
MIN_VERSION = packaging.version.Version("13.0.0")
MAIN_BRANCH = "main"
TAG_PATTERN = re.compile(
    f"^release/({packaging.version.VERSION_PATTERN})$", re.IGNORECASE | re.VERBOSE
)
REMOTE = "origin"
BRANCH_PATTERN = re.compile(
    f"^{REMOTE}/((stable|releng)/({packaging.version.VERSION_PATTERN}))$",
    re.IGNORECASE | re.VERBOSE,
)

# Normally uses /run/user/*, which is on a tmpfs and too small
temp_dir = tempfile.TemporaryDirectory(dir="/tmp")
print(f"Selected temporary directory {temp_dir.name}")

if len(sys.argv) >= 2:
    orig_repo = git.Repo(sys.argv[1])
    orig_repo.remote("origin").fetch()
else:
    print("Cloning source repo")
    orig_repo = git.Repo.clone_from(
        "https://git.FreeBSD.org/src.git", to_path=os.path.join(temp_dir.name, "orig")
    )


print("doing git crimes, do not run `git worktree prune` until after script finishes!")
workdir = os.path.join(temp_dir.name, "work")
git.cmd.Git(orig_repo.git_dir).worktree("add", "--orphan", workdir)

# Have to create object before removing .git otherwise it will complain
repo = git.Repo(workdir)
repo.git.set_persistent_git_options(git_dir=repo.git_dir)
# Remove so that nix hash doesn't see the file
os.remove(os.path.join(workdir, ".git"))

print(f"Working in directory {repo.working_dir} with git directory {repo.git_dir}")

versions = dict()
for tag in repo.tags:
    m = TAG_PATTERN.match(tag.name)
    if m is None:
        continue
    version = packaging.version.parse(m[1])
    if version < MIN_VERSION:
        print(f"Skipping old tag {tag.name} ({version})")
        continue

    print(f"Trying tag {tag.name} ({version})")

    result = handle_commit(repo, tag.commit, tag.name, "tag")
    versions[tag.name] = result

for branch in repo.remote("origin").refs:
    m = BRANCH_PATTERN.match(branch.name)
    if m is not None:
        fullname = m[1]
        version = packaging.version.parse(m[3])
        if version < MIN_VERSION:
            print(f"Skipping old branch {fullname} ({version})")
            continue
        print(f"Trying branch {fullname} ({version})")
    elif branch.name == f"{REMOTE}/{MAIN_BRANCH}":
        fullname = MAIN_BRANCH
        print(f"Trying development branch {fullname}")
    else:
        continue

    result = handle_commit(repo, branch.commit, fullname, "branch")
    versions[fullname] = result


with open(os.path.join(BASE_DIR, "versions.json"), "w") as out:
    json.dump(versions, out, sort_keys=True)
