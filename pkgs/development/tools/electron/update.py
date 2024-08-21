#! /usr/bin/env nix-shell
#! nix-shell -i python -p python3.pkgs.joblib python3.pkgs.click python3.pkgs.click-log nix nix-prefetch-git nurl prefetch-yarn-deps prefetch-npm-deps
"""
electron updater

A script for updating both binary and source hashes.

It supports the following modes:

| Mode         | Description                                     |
|------------- | ----------------------------------------------- |
| `update`     | for updating a specific Electron release        |
| `update-all` | for updating all electron releases at once      |
| `eval`       | just print the necessary sources to fetch       |

The `eval` and `update` commands accept an optional `--version` flag
to restrict the mechanism only to a given major release.

The `update` and `update-all` commands accept an optional `--commit`
flag to automatically commit the changes for you.

The `update` and `update-all` commands accept optional `--bin-only`
and `--source-only` flags to restict the update to binary or source
releases.
"""
import base64
import csv
import json
import logging
import os
import random
import re
import subprocess
import sys
import tempfile
import traceback
import urllib.request

from abc import ABC
from codecs import iterdecode
from datetime import datetime
from typing import Iterable, Optional, Tuple
from urllib.request import urlopen

import click
import click_log

from joblib import Parallel, delayed, Memory

depot_tools_checkout = tempfile.TemporaryDirectory()
subprocess.check_call(
    [
        "nix-prefetch-git",
        "--builder",
        "--quiet",
        "--url",
        "https://chromium.googlesource.com/chromium/tools/depot_tools",
        "--out",
        depot_tools_checkout.name,
        "--rev",
        "7a69b031d58081d51c9e8e89557b343bba8518b1",
    ]
)
sys.path.append(depot_tools_checkout.name)

import gclient_eval
import gclient_utils


# Relative path to the electron-source info.json
SOURCE_INFO_JSON = "info.json"

# Relatice path to the electron-bin info.json
BINARY_INFO_JSON = "binary/info.json"

# Relative path the the electron-chromedriver info.json
CHROMEDRIVER_INFO_JSON = "chromedriver/info.json"

# Number of spaces used for each indentation level
JSON_INDENT = 4

os.chdir(os.path.dirname(__file__))

memory: Memory = Memory("cache", verbose=0)

logger = logging.getLogger(__name__)
click_log.basic_config(logger)

nixpkgs_path = os.path.dirname(os.path.realpath(__file__)) + "/../../../.."


class Repo:
    fetcher: str
    args: dict

    def __init__(self) -> None:
        self.deps: dict = {}
        self.hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="

    def get_deps(self, repo_vars: dict, path: str) -> None:
        print(
            "evaluating " + json.dumps(self, default=vars, sort_keys=True),
            file=sys.stderr,
        )

        deps_file = self.get_file("DEPS")
        evaluated = gclient_eval.Parse(deps_file, filename="DEPS")

        repo_vars = dict(evaluated["vars"]) | repo_vars

        prefix = f"{path}/" if evaluated.get("use_relative_paths", False) else ""

        self.deps = {
            prefix + dep_name: repo_from_dep(dep)
            for dep_name, dep in evaluated["deps"].items()
            if (
                gclient_eval.EvaluateCondition(dep["condition"], repo_vars)
                if "condition" in dep
                else True
            )
            and repo_from_dep(dep) != None
        }

        for key in evaluated.get("recursedeps", []):
            dep_path = prefix + key
            if dep_path in self.deps and dep_path != "src/third_party/squirrel.mac":
                self.deps[dep_path].get_deps(repo_vars, dep_path)

    def prefetch(self) -> None:
        self.hash = get_repo_hash(self.fetcher, self.args)

    def prefetch_all(self) -> int:
        return sum(
            [dep.prefetch_all() for [_, dep] in self.deps.items()],
            [delayed(self.prefetch)()],
        )

    def flatten_repr(self) -> dict:
        return {"fetcher": self.fetcher, "hash": self.hash, **self.args}

    def flatten(self, path: str) -> dict:
        out = {path: self.flatten_repr()}
        for dep_path, dep in self.deps.items():
            out |= dep.flatten(dep_path)
        return out

    def get_file(self, filepath: str) -> str:
        raise NotImplementedError


class GitRepo(Repo):
    def __init__(self, url: str, rev: str) -> None:
        super().__init__()
        self.fetcher = "fetchgit"
        self.args = {
            "url": url,
            "rev": rev,
        }


class GitHubRepo(Repo):
    def __init__(self, owner: str, repo: str, rev: str) -> None:
        super().__init__()
        self.fetcher = "fetchFromGitHub"
        self.args = {
            "owner": owner,
            "repo": repo,
            "rev": rev,
        }

    def get_file(self, filepath: str) -> str:
        return (
            urlopen(
                f"https://raw.githubusercontent.com/{self.args['owner']}/{self.args['repo']}/{self.args['rev']}/{filepath}"
            )
            .read()
            .decode("utf-8")
        )


class GitilesRepo(Repo):
    def __init__(self, url: str, rev: str) -> None:
        super().__init__()
        self.fetcher = "fetchFromGitiles"
        # self.fetcher = 'fetchgit'
        self.args = {
            "url": url,
            "rev": rev,
            # "fetchSubmodules": "false",
        }

        if url == "https://chromium.googlesource.com/chromium/src.git":
            self.args["postFetch"] = "rm -r $out/third_party/blink/web_tests; "
            self.args["postFetch"] += "rm -r $out/third_party/hunspell/tests; "
            self.args["postFetch"] += "rm -r $out/content/test/data; "
            self.args["postFetch"] += "rm -r $out/courgette/testdata; "
            self.args["postFetch"] += "rm -r $out/extensions/test/data; "
            self.args["postFetch"] += "rm -r $out/media/test/data; "

    def get_file(self, filepath: str) -> str:
        return base64.b64decode(
            urlopen(
                f"{self.args['url']}/+/{self.args['rev']}/{filepath}?format=TEXT"
            ).read()
        ).decode("utf-8")


class ElectronBinRepo(GitHubRepo):
    def __init__(self, owner: str, repo: str, rev: str) -> None:
        super().__init__(owner, repo, rev)
        self.systems = {
            "i686-linux": "linux-ia32",
            "x86_64-linux": "linux-x64",
            "armv7l-linux": "linux-armv7l",
            "aarch64-linux": "linux-arm64",
            "x86_64-darwin": "darwin-x64",
            "aarch64-darwin": "darwin-arm64",
        }

    def get_shasums256(self, version: str) -> list:
        """Returns the contents of SHASUMS256.txt"""
        try:
            called_process: subprocess.CompletedProcess = subprocess.run(
                [
                    "nix-prefetch-url",
                    "--print-path",
                    f"https://github.com/electron/electron/releases/download/v{version}/SHASUMS256.txt",
                ],
                capture_output=True,
                check=True,
                text=True,
            )

            hash_file_path = called_process.stdout.split("\n")[1]

            with open(hash_file_path, "r") as f:
                return f.read().split("\n")

        except subprocess.CalledProcessError as err:
            print(err.stderr)
            sys.exit(1)

    def get_headers(self, version: str) -> str:
        """Returns the hash of the release headers tarball"""
        try:
            called_process: subprocess.CompletedProcess = subprocess.run(
                [
                    "nix-prefetch-url",
                    f"https://artifacts.electronjs.org/headers/dist/v{version}/node-v{version}-headers.tar.gz",
                ],
                capture_output=True,
                check=True,
                text=True,
            )
            return called_process.stdout.split("\n")[0]
        except subprocess.CalledProcessError as err:
            print(err.stderr)
            sys.exit(1)

    def get_hashes(self, major_version: str) -> dict:
        """Returns a dictionary of hashes for a given major version"""
        m, _ = get_latest_version(major_version)
        version: str = m["version"]

        out = {}
        out[major_version] = {
            "hashes": {},
            "version": version,
        }

        hashes: list = self.get_shasums256(version)

        for nix_system, electron_system in self.systems.items():
            filename = f"*electron-v{version}-{electron_system}.zip"
            if any([x.endswith(filename) for x in hashes]):
                out[major_version]["hashes"][nix_system] = [
                    x.split(" ")[0] for x in hashes if x.endswith(filename)
                ][0]
                out[major_version]["hashes"]["headers"] = self.get_headers(version)

        return out


class ElectronChromedriverRepo(ElectronBinRepo):
    def __init__(self, rev: str) -> None:
        super().__init__("electron", "electron", rev)
        self.systems = {
            "i686-linux": "linux-ia32",
            "x86_64-linux": "linux-x64",
            "armv7l-linux": "linux-armv7l",
            "aarch64-linux": "linux-arm64",
            "x86_64-darwin": "darwin-x64",
            "aarch64-darwin": "darwin-arm64",
        }

    def get_hashes(self, major_version: str) -> dict:
        """Returns a dictionary of hashes for a given major version"""
        m, _ = get_latest_version(major_version)
        version: str = m["version"]

        out = {}
        out[major_version] = {
            "hashes": {},
            "version": version,
        }

        hashes: list = self.get_shasums256(version)

        for nix_system, electron_system in self.systems.items():
            filename = f"*chromedriver-v{version}-{electron_system}.zip"
            if any([x.endswith(filename) for x in hashes]):
                out[major_version]["hashes"][nix_system] = [
                    x.split(" ")[0] for x in hashes if x.endswith(filename)
                ][0]
                out[major_version]["hashes"]["headers"] = self.get_headers(version)

        return out


# Releases that have reached end-of-life no longer receive any updates
# and it is rather pointless trying to update those.
#
# https://endoflife.date/electron
@memory.cache
def supported_version_range() -> range:
    """Returns a range of electron releases that have not reached end-of-life yet"""
    releases_json = json.loads(
        urlopen("https://endoflife.date/api/electron.json").read()
    )
    supported_releases = [
        int(x["cycle"])
        for x in releases_json
        if x["eol"] == False
        or datetime.strptime(x["eol"], "%Y-%m-%d") > datetime.today()
    ]

    return range(
        min(supported_releases),  # incl.
        # We have also packaged the beta release in nixpkgs,
        # but it is not tracked by endoflife.date
        max(supported_releases) + 2,  # excl.
        1,
    )


@memory.cache
def get_repo_hash(fetcher: str, args: dict) -> str:
    expr = f"with import {nixpkgs_path} {{}};{fetcher}{{"
    for key, val in args.items():
        expr += f'{key}="{val}";'
    expr += "}"
    cmd = ["nurl", "-H", "--expr", expr]
    print(" ".join(cmd), file=sys.stderr)
    out = subprocess.check_output(cmd)
    return out.decode("utf-8").strip()


@memory.cache
def _get_yarn_hash(path: str) -> str:
    print(f"prefetch-yarn-deps", file=sys.stderr)
    with tempfile.TemporaryDirectory() as tmp_dir:
        with open(tmp_dir + "/yarn.lock", "w") as f:
            f.write(path)
        return (
            subprocess.check_output(["prefetch-yarn-deps", tmp_dir + "/yarn.lock"])
            .decode("utf-8")
            .strip()
        )


def get_yarn_hash(repo: Repo, yarn_lock_path: str = "yarn.lock") -> str:
    return _get_yarn_hash(repo.get_file(yarn_lock_path))


@memory.cache
def _get_npm_hash(filename: str) -> str:
    print(f"prefetch-npm-deps", file=sys.stderr)
    with tempfile.TemporaryDirectory() as tmp_dir:
        with open(tmp_dir + "/package-lock.json", "w") as f:
            f.write(filename)
        return (
            subprocess.check_output(
                ["prefetch-npm-deps", tmp_dir + "/package-lock.json"]
            )
            .decode("utf-8")
            .strip()
        )


def get_npm_hash(repo: Repo, package_lock_path: str = "package-lock.json") -> str:
    return _get_npm_hash(repo.get_file(package_lock_path))


def repo_from_dep(dep: dict) -> Optional[Repo]:
    if "url" in dep:
        url, rev = gclient_utils.SplitUrlRevision(dep["url"])

        search_object = re.search(r"https://github.com/(.+)/(.+?)(\.git)?$", url)
        if search_object:
            return GitHubRepo(search_object.group(1), search_object.group(2), rev)

        if re.match(r"https://.+.googlesource.com", url):
            return GitilesRepo(url, rev)

        return GitRepo(url, rev)
    else:
        # Not a git dependency; skip
        return None


def get_gn_source(repo: Repo) -> dict:
    gn_pattern = r"'gn_version': 'git_revision:([0-9a-f]{40})'"
    gn_commit = re.search(gn_pattern, repo.get_file("DEPS")).group(1)
    gn_prefetch: bytes = subprocess.check_output(
        [
            "nix-prefetch-git",
            "--quiet",
            "https://gn.googlesource.com/gn",
            "--rev",
            gn_commit,
        ]
    )
    gn: dict = json.loads(gn_prefetch)
    return {
        "gn": {
            "version": datetime.fromisoformat(gn["date"]).date().isoformat(),
            "url": gn["url"],
            "rev": gn["rev"],
            "hash": gn["hash"],
        }
    }


def get_latest_version(major_version: str) -> Tuple[str, str]:
    """Returns the latest version for a given major version"""
    electron_releases: dict = json.loads(
        urlopen("https://releases.electronjs.org/releases.json").read()
    )
    major_version_releases = filter(
        lambda item: item["version"].startswith(f"{major_version}."), electron_releases
    )
    m = max(major_version_releases, key=lambda item: item["date"])

    rev = f"v{m['version']}"
    return (m, rev)


def get_electron_bin_info(major_version: str) -> Tuple[str, str, ElectronBinRepo]:
    m, rev = get_latest_version(major_version)

    electron_repo: ElectronBinRepo = ElectronBinRepo("electron", "electron", rev)
    return (major_version, m, electron_repo)


def get_electron_chromedriver_info(
    major_version: str,
) -> Tuple[str, str, ElectronChromedriverRepo]:
    m, rev = get_latest_version(major_version)

    electron_repo: ElectronChromedriverRepo = ElectronChromedriverRepo(rev)
    return (major_version, m, electron_repo)


def get_electron_info(major_version: str) -> Tuple[str, str, GitHubRepo]:
    m, rev = get_latest_version(major_version)

    electron_repo: GitHubRepo = GitHubRepo("electron", "electron", rev)
    electron_repo.get_deps(
        {
            f"checkout_{platform}": platform == "linux"
            for platform in ["ios", "chromeos", "android", "mac", "win", "linux"]
        },
        "src/electron",
    )

    return (major_version, m, electron_repo)


def get_update(repo: Tuple[str, str, Repo]) -> Tuple[str, dict]:
    (major_version, m, electron_repo) = repo

    tasks = electron_repo.prefetch_all()
    a = lambda: (("electron_yarn_hash", get_yarn_hash(electron_repo)))
    tasks.append(delayed(a)())
    a = lambda: (
        (
            "chromium_npm_hash",
            get_npm_hash(
                electron_repo.deps["src"], "third_party/node/package-lock.json"
            ),
        )
    )
    tasks.append(delayed(a)())
    random.shuffle(tasks)

    task_results = {
        n[0]: n[1]
        for n in Parallel(n_jobs=3, require="sharedmem", return_as="generator")(tasks)
        if n != None
    }

    tree = electron_repo.flatten("src/electron")

    return (
        f"{major_version}",
        {
            "deps": tree,
            **{key: m[key] for key in ["version", "modules", "chrome", "node"]},
            "chromium": {
                "version": m["chrome"],
                "deps": get_gn_source(electron_repo.deps["src"]),
            },
            **task_results,
        },
    )


def load_info_json(path: str) -> dict:
    """Load the contents of a JSON file

    Args:
        path: The path to the JSON file

    Returns: An empty dict if the path does not exist, otherwise the contents of the JSON file.
    """
    try:
        with open(path, "r") as f:
            return json.loads(f.read())
    except:
        return {}


def save_info_json(path: str, content: dict) -> None:
    """Saves the given info to a JSON file

    Args:
        path: The path where the info should be saved
        content: The content to be saved as JSON.
    """
    with open(path, "w") as f:
        f.write(json.dumps(content, indent=JSON_INDENT, default=vars, sort_keys=True))
        f.write("\n")


def update_bin(major_version: str, commit: bool) -> None:
    """Update a given electron-bin release

    Args:
        major_version: The major version number, e.g. '27'
        commit: Whether the updater should commit the result
    """
    package_name = f"electron_{major_version}-bin"
    print(f"Updating {package_name}")

    electron_bin_info = get_electron_bin_info(major_version)
    (_major_version, _version, repo) = electron_bin_info

    old_info = load_info_json(BINARY_INFO_JSON)
    new_info = repo.get_hashes(major_version)

    out = old_info | new_info

    save_info_json(BINARY_INFO_JSON, out)

    old_version = (
        old_info[major_version]["version"] if major_version in old_info else None
    )
    new_version = new_info[major_version]["version"]
    if old_version == new_version:
        print(f"{package_name} is up-to-date")
    elif commit:
        commit_result(package_name, old_version, new_version, BINARY_INFO_JSON)


def update_chromedriver(major_version: str, commit: bool) -> None:
    """Update a given electron-chromedriver release

    Args:
        major_version: The major version number, e.g. '27'
        commit: Whether the updater should commit the result
    """
    package_name = f"electron-chromedriver_{major_version}"
    print(f"Updating {package_name}")

    electron_chromedriver_info = get_electron_chromedriver_info(major_version)
    (_major_version, _version, repo) = electron_chromedriver_info

    old_info = load_info_json(CHROMEDRIVER_INFO_JSON)
    new_info = repo.get_hashes(major_version)

    out = old_info | new_info

    save_info_json(CHROMEDRIVER_INFO_JSON, out)

    old_version = (
        old_info[major_version]["version"] if major_version in old_info else None
    )
    new_version = new_info[major_version]["version"]
    if old_version == new_version:
        print(f"{package_name} is up-to-date")
    elif commit:
        commit_result(package_name, old_version, new_version, CHROMEDRIVER_INFO_JSON)


def update_source(major_version: str, commit: bool) -> None:
    """Update a given electron-source release

    Args:
        major_version: The major version number, e.g. '27'
        commit: Whether the updater should commit the result
    """
    package_name = f"electron-source.electron_{major_version}"
    print(f"Updating electron-source.electron_{major_version}")

    old_info = load_info_json(SOURCE_INFO_JSON)
    old_version = (
        old_info[str(major_version)]["version"]
        if str(major_version) in old_info
        else None
    )

    electron_source_info = get_electron_info(major_version)
    new_info = get_update(electron_source_info)
    out = old_info | {new_info[0]: new_info[1]}

    save_info_json(SOURCE_INFO_JSON, out)

    new_version = new_info[1]["version"]
    if old_version == new_version:
        print(f"{package_name} is up-to-date")
    elif commit:
        commit_result(package_name, old_version, new_version, SOURCE_INFO_JSON)


def non_eol_releases(releases: Iterable[int]) -> Iterable[int]:
    """Returns a list of releases that have not reached end-of-life yet."""
    return tuple(filter(lambda x: x in supported_version_range(), releases))


def update_all_source(commit: bool) -> None:
    """Update all eletron-source releases at once

    Args:
        commit: Whether to commit the result
    """
    old_info = load_info_json(SOURCE_INFO_JSON)

    filtered_releases = non_eol_releases(tuple(map(lambda x: int(x), old_info.keys())))

    # This might take some time
    repos = Parallel(n_jobs=2, require="sharedmem")(
        delayed(get_electron_info)(major_version) for major_version in filtered_releases
    )
    new_info = {
        n[0]: n[1]
        for n in Parallel(n_jobs=2, require="sharedmem")(
            delayed(get_update)(repo) for repo in repos
        )
    }

    if commit:
        for major_version in filtered_releases:
            # Since the sources have been fetched at this point already,
            # fetching them again will be much faster.
            update_source(str(major_version), commit)
    else:
        out = old_info | {new_info[0]: new_info[1]}
        save_info_json(SOURCE_INFO_JSON, out)


def parse_cve_numbers(tag_name: str) -> Iterable[str]:
    """Returns mentioned CVE numbers from a given release tag"""
    cve_pattern = r"CVE-\d{4}-\d+"
    url = f"https://api.github.com/repos/electron/electron/releases/tags/{tag_name}"
    headers = {
        "Accept": "application/vnd.github+json",
        "X-GitHub-Api-Version": "2022-11-28",
    }
    request = urllib.request.Request(url=url, headers=headers)
    release_note = ""
    try:
        with urlopen(request) as response:
            release_note = json.loads(response.read().decode("utf-8"))["body"]
    except:
        print(
            f"WARN: Fetching release note for {tag_name} from GitHub failed!",
            file=sys.stderr,
        )

    return sorted(re.findall(cve_pattern, release_note))


def commit_result(
    package_name: str, old_version: Optional[str], new_version: str, path: str
) -> None:
    """Creates a git commit with a short description of the change

    Args:
        package_name: The package name, e.g. `electron-source.electron-{major_version}`
            or `electron_{major_version}-bin`

        old_version: Version number before the update.
            Can be left empty when initializing a new release.

        new_version: Version number after the update.

        path: Path to the lockfile to be committed
    """
    assert (
        isinstance(package_name, str) and len(package_name) > 0
    ), "Argument `package_name` cannot be empty"
    assert (
        isinstance(new_version, str) and len(new_version) > 0
    ), "Argument `new_version` cannot be empty"

    if old_version != new_version:
        major_version = new_version.split(".")[0]
        cve_fixes_text = "\n".join(
            list(
                map(lambda cve: f"- Fixes {cve}", parse_cve_numbers(f"v{new_version}"))
            )
        )
        init_msg = f"init at {new_version}"
        update_msg = f"{old_version} -> {new_version}"
        diff = (
            f"- Diff: https://github.com/electron/electron/compare/refs/tags/v{old_version}...v{new_version}\n"
            if old_version != None
            else ""
        )
        commit_message = f"""{package_name}: {update_msg if old_version != None else init_msg}

- Changelog: https://github.com/electron/electron/releases/tag/v{new_version}
{diff}{cve_fixes_text}
"""
        subprocess.run(
            [
                "git",
                "add",
                path,
            ]
        )
        subprocess.run(
            [
                "git",
                "commit",
                "-m",
                commit_message,
            ]
        )


@click.group()
def cli() -> None:
    """A script for updating electron-bin and electron-source hashes"""
    pass


@cli.command(
    "eval", help="Print the necessary sources to fetch for a given major release"
)
@click.option("--version", help="The major version, e.g. '23'")
def eval(version):
    (_, _, repo) = electron_repo = get_electron_info(version)
    tree = repo.flatten("src/electron")
    print(json.dumps(tree, indent=JSON_INDENT, default=vars, sort_keys=True))


@cli.command("update-chromedriver", help="Update a single major release")
@click.option("-v", "--version", help="The major version, e.g. '23'")
@click.option("-c", "--commit", is_flag=True, default=False, help="Commit the result")
def update_chromedriver_cmd(version: str, commit: bool) -> None:
    update_chromedriver(version, commit)


@cli.command("update", help="Update a single major release")
@click.option("-v", "--version", help="The major version, e.g. '23'")
@click.option(
    "-b",
    "--bin-only",
    is_flag=True,
    default=False,
    help="Only update electron-bin packages",
)
@click.option(
    "-s",
    "--source-only",
    is_flag=True,
    default=False,
    help="Only update electron-source packages",
)
@click.option("-c", "--commit", is_flag=True, default=False, help="Commit the result")
def update(version: str, bin_only: bool, source_only: bool, commit: bool) -> None:
    assert isinstance(version, str) and len(version) > 0, "version must be non-empty"

    if bin_only and source_only:
        print(
            "Error: Omit --bin-only and --source-only if you want to update both source and binary packages.",
            file=sys.stderr,
        )
        sys.exit(1)

    elif bin_only:
        update_bin(version, commit)

    elif source_only:
        update_source(version, commit)

    else:
        update_bin(version, commit)
        update_source(version, commit)

    update_chromedriver(version, commit)


@cli.command("update-all", help="Update all releases at once")
@click.option(
    "-b",
    "--bin-only",
    is_flag=True,
    default=False,
    help="Only update electron-bin packages",
)
@click.option(
    "-s",
    "--source-only",
    is_flag=True,
    default=False,
    help="Only update electron-source packages",
)
@click.option("-c", "--commit", is_flag=True, default=False, help="Commit the result")
def update_all(bin_only: bool, source_only: bool, commit: bool) -> None:
    # Filter out releases that have reached end-of-life
    filtered_bin_info = dict(
        filter(
            lambda entry: int(entry[0]) in supported_version_range(),
            load_info_json(BINARY_INFO_JSON).items(),
        )
    )

    if bin_only and source_only:
        print(
            "Error: omit --bin-only and --source-only if you want to update both source and binary packages.",
            file=sys.stderr,
        )
        sys.exit(1)

    elif bin_only:
        for major_version, _ in filtered_bin_info.items():
            update_bin(major_version, commit)

    elif source_only:
        update_all_source(commit)

    else:
        for major_version, _ in filtered_bin_info.items():
            update_bin(major_version, commit)

        update_all_source(commit)

    for major_version, _ in filtered_bin_info.items():
        update_chromedriver(major_version, commit)


if __name__ == "__main__":
    cli()
