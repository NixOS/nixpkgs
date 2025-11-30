#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p git "python3.withPackages (ps: with ps; [ gitpython packaging beautifulsoup4 pandas lxml ])"

import bs4
import git
import io
import json
import os
import packaging.version
import pandas
import re
import subprocess
import sys
import tarfile
import tempfile
import typing
import urllib.request

_QUERY_VERSION_PATTERN = re.compile('^([A-Z]+)="(.+)"$')
_RELEASE_PATCH_PATTERN = re.compile("^RELEASE-p([0-9]+)$")
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


def request_supported_refs() -> list[str]:
    # Looks pretty shady but I think this should work with every version of the page in the last 20 years
    r = re.compile(r"^h\d$", re.IGNORECASE)
    soup = bs4.BeautifulSoup(
        urllib.request.urlopen("https://www.freebsd.org/security"), features="lxml"
    )
    header = soup.find(
        lambda tag: r.match(tag.name) is not None
        and tag.text.lower() == "supported freebsd releases"
    )
    table = header.find_next("table")
    df = pandas.read_html(io.StringIO(table.prettify()))[0]
    return list(df["Branch"])


def query_version(work_dir: str) -> dict[str, typing.Any]:
    # This only works on FreeBSD 13 and later
    text = (
        subprocess.check_output(
            ["bash", os.path.join(work_dir, "sys", "conf", "newvers.sh"), "-v"]
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

    parsed = packaging.version.parse(fields["revision"])
    fields["major"] = parsed.major
    fields["minor"] = parsed.minor

    # Extract the patch number from `RELEASE-p<patch>`, which is used
    # e.g. in the "releng" branches.
    m = _RELEASE_PATCH_PATTERN.match(fields["branch"])
    if m is not None:
        fields["patch"] = m[1]

    return fields


def handle_commit(
    repo: git.Repo,
    rev: git.objects.commit.Commit,
    ref_name: str,
    ref_type: str,
    supported_refs: list[str],
    old_versions: dict[str, typing.Any],
) -> dict[str, typing.Any]:
    if old_versions.get(ref_name, {}).get("rev", None) == rev.hexsha:
        print(f"{ref_name}: revision still {rev.hexsha}, skipping")
        return old_versions[ref_name]

    tar_content = io.BytesIO()
    repo.archive(tar_content, rev, format="tar")
    tar_content.seek(0)

    with tempfile.TemporaryDirectory(dir="/tmp") as work_dir:
        file = tarfile.TarFile(fileobj=tar_content)
        file.extractall(path=work_dir, filter="data")

        full_hash = (
            subprocess.check_output(["nix", "hash", "path", "--sri", work_dir])
            .decode("utf-8")
            .strip()
        )
        print(f"{ref_name}: hash is {full_hash}")

        version = query_version(work_dir)
        print(f"{ref_name}: version is {version['version']}")

    return {
        "rev": rev.hexsha,
        "hash": full_hash,
        "ref": ref_name,
        "refType": ref_type,
        "supported": ref_name in supported_refs,
        "version": version,
    }


def main() -> None:
    # Normally uses /run/user/*, which is on a tmpfs and too small
    temp_dir = tempfile.TemporaryDirectory(dir="/tmp")
    print(f"Selected temporary directory {temp_dir.name}")

    if len(sys.argv) >= 2:
        repo = git.Repo(sys.argv[1])
        print(f"Fetching updates on {repo.git_dir}")
        repo.remote("origin").fetch()
    else:
        print("Cloning source repo")
        repo = git.Repo.clone_from(
            "https://git.FreeBSD.org/src.git", to_path=temp_dir.name
        )

    supported_refs = request_supported_refs()
    print(f"Supported refs are: {' '.join(supported_refs)}")

    print(f"git directory {repo.git_dir}")

    try:
        with open(os.path.join(BASE_DIR, "versions.json"), "r") as f:
            old_versions = json.load(f)
    except FileNotFoundError:
        old_versions = dict()

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

        result = handle_commit(
            repo, tag.commit, tag.name, "tag", supported_refs, old_versions
        )

        # Hack in the patch version from parsing the tag, if we didn't
        # get one from the "branch" field (from newvers). This is
        # probably 0.
        versionObj = result["version"]
        if "patch" not in versionObj:
            versionObj["patch"] = version.micro

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

        result = handle_commit(
            repo, branch.commit, fullname, "branch", supported_refs, old_versions
        )
        versions[fullname] = result

    with open(os.path.join(BASE_DIR, "versions.json"), "w") as out:
        json.dump(versions, out, sort_keys=True, indent=2)
        out.write("\n")


if __name__ == "__main__":
    main()
