#! /usr/bin/env nix-shell
#! nix-shell -i python -p "python3.withPackages (ps: [ps.pygithub ps.packaging])" git gnupg

# This is automatically called by ../update.sh.

from __future__ import annotations

import json
import os
import re
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path
from tempfile import TemporaryDirectory
from typing import (
    Dict,
    Iterator,
    List,
    Optional,
    Sequence,
    Tuple,
    TypedDict,
    Union,
)

from github import Github
from github.GitRelease import GitRelease

from packaging.version import parse as parse_version, Version

VersionComponent = Union[int, str]
Version = List[VersionComponent]


PatchData = TypedDict("PatchData", {"name": str, "url": str, "sha256": str, "extra": str})
Patch = TypedDict("Patch", {
    "patch": PatchData,
    "version": str,
    "sha256": str,
})


def read_min_kernel_branch() -> List[str]:
    with open(NIXPKGS_KERNEL_PATH / "kernels-org.json") as f:
        return list(parse_version(sorted(json.load(f).keys())[0]).release)


@dataclass
class ReleaseInfo:
    version: Version
    release: GitRelease


HERE = Path(__file__).resolve().parent
NIXPKGS_KERNEL_PATH = HERE.parent
NIXPKGS_PATH = HERE.parents[4]
HARDENED_GITHUB_REPO = "anthraxx/linux-hardened"
HARDENED_TRUSTED_KEY = HERE / "anthraxx.asc"
HARDENED_PATCHES_PATH = HERE / "patches.json"
MIN_KERNEL_VERSION: Version = read_min_kernel_branch()


def run(*args: Union[str, Path]) -> subprocess.CompletedProcess[bytes]:
    try:
        return subprocess.run(
            args,
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            encoding="utf-8",
        )
    except subprocess.CalledProcessError as err:
        print(
            f"error: `{err.cmd}` failed unexpectedly\n"
            f"status code: {err.returncode}\n"
            f"stdout:\n{err.stdout.strip()}\n"
            f"stderr:\n{err.stderr.strip()}",
            file=sys.stderr,
        )
        sys.exit(1)


def nix_prefetch_url(url: str) -> Tuple[str, Path]:
    output = run("nix-prefetch-url", "--print-path", url).stdout
    sha256, path = output.strip().split("\n")
    return sha256, Path(path)


def verify_openpgp_signature(
    *, name: str, trusted_key: Path, sig_path: Path, data_path: Path,
) -> bool:
    with TemporaryDirectory(suffix=".nixpkgs-gnupg-home") as gnupg_home_str:
        gnupg_home = Path(gnupg_home_str)
        run("gpg", "--homedir", gnupg_home, "--import", trusted_key)
        keyring = gnupg_home / "pubring.kbx"
        try:
            subprocess.run(
                ("gpgv", "--keyring", keyring, sig_path, data_path),
                check=True,
                stderr=subprocess.PIPE,
                encoding="utf-8",
            )
            return True
        except subprocess.CalledProcessError as err:
            print(
                f"error: signature for {name} failed to verify!",
                file=sys.stderr,
            )
            print(err.stderr, file=sys.stderr, end="")
            return False


def fetch_patch(*, name: str, release_info: ReleaseInfo) -> Optional[Patch]:
    release = release_info.release
    extra = f'-{release_info.version[-1]}'

    def find_asset(filename: str) -> str:
        try:
            it: Iterator[str] = (
                asset.browser_download_url
                for asset in release.get_assets()
                if asset.name == filename
            )
            return next(it)
        except StopIteration:
            raise KeyError(filename)

    patch_filename = f"{name}.patch"
    try:
        patch_url = find_asset(patch_filename)
        sig_url = find_asset(patch_filename + ".sig")
    except KeyError:
        print(f"error: {patch_filename}{{,.sig}} not present", file=sys.stderr)
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

    kernel_ver = re.sub(r"v?(.*)(-hardened[\d]+)$", r'\1', release_info.release.tag_name)
    major = kernel_ver.split('.')[0]
    sha256_kernel, _ = nix_prefetch_url(f"mirror://kernel/linux/kernel/v{major}.x/linux-{kernel_ver}.tar.xz")

    return Patch(
        patch=PatchData(name=patch_filename, url=patch_url, sha256=sha256, extra=extra),
        version=kernel_ver,
        sha256=sha256_kernel
    )


def normalize_kernel_version(version_str: str) -> list[str|int]:
    # There have been two variants v6.10[..] and 6.10[..], drop the v
    version_str_without_v = version_str[1:] if not version_str[0].isdigit() else version_str

    version: list[str|int] = []

    for component in re.split(r'\.|\-', version_str_without_v):
        try:
            version.append(int(component))
        except ValueError:
            version.append(component)
    return version


def version_string(version: Version) -> str:
    return ".".join(str(component) for component in version)


def major_kernel_version_key(kernel_version: list[int|str]) -> str:
    return version_string(kernel_version[:-1])


def commit_patches(*, kernel_key: Version, message: str) -> None:
    new_patches_path = HARDENED_PATCHES_PATH.with_suffix(".new")
    with open(new_patches_path, "w") as new_patches_file:
        json.dump(patch_json, new_patches_file, indent=4, sort_keys=True)
        new_patches_file.write("\n")
    os.rename(new_patches_path, HARDENED_PATCHES_PATH)
    message = f"linux/hardened/patches/{kernel_key}: {message}"
    print(message)
    if os.environ.get("COMMIT"):
        run(
            "git",
            "-C",
            NIXPKGS_PATH,
            "commit",
            f"--message={message}",
            HARDENED_PATCHES_PATH,
        )


# Load the existing patches.
with open(HARDENED_PATCHES_PATH) as patches_file:
    patch_json = json.load(patches_file)
    patch_versions = set([parse_version(k) for k in patch_json.keys()])

with open(NIXPKGS_KERNEL_PATH / "kernels-org.json") as kernel_versions_json:
    kernel_versions = json.load(kernel_versions_json)

    kernels = {
        parse_version(version): meta
        for version, meta in kernel_versions.items()
        if version != "testing"
    }

    latest_lts = sorted(ver for ver, meta in kernels.items() if meta.get("lts", False))[-1]
    keys = sorted(kernels.keys())
    latest_release = keys[-1]
    fallback = keys[-2]

g = Github(os.environ.get("GITHUB_TOKEN"))
repo = g.get_repo(HARDENED_GITHUB_REPO)
failures = False

all_candidates = set([latest_lts, latest_release, fallback])
kernels_to_package = {}
for release in repo.get_releases()[:30]:
    version = normalize_kernel_version(release.tag_name)
    # needs to look like e.g. 5.6.3-hardened1
    if len(version) < 4:
        continue

    if not (isinstance(version[-2], int)):
        continue

    kernel_version = version[:-1]
    kernel_key = parse_version(major_kernel_version_key(kernel_version))

    if kernel_key not in all_candidates:
        continue

    try:
        found = kernels_to_package[kernel_key]
        if found.version > version:
            continue
    except KeyError:
        pass

    kernels_to_package[kernel_key] = ReleaseInfo(version=version, release=release)

if latest_release in kernels_to_package:
    if fallback != latest_lts:
        del kernels_to_package[fallback]
    kernel_versions = set([latest_lts, latest_release])
else:
    kernel_versions = set([latest_lts, fallback])

# Remove patches for unpackaged kernel versions.
removals = False
for kernel_key in sorted(patch_versions - kernels_to_package.keys()):
    del patch_json[str(kernel_key)]
    removals = True
    commit_patches(kernel_key=kernel_key, message="remove")

# Update hardened-patches.json for each release.
for kernel_key in sorted(kernels_to_package.keys()):
    release_info = kernels_to_package[kernel_key]
    release = release_info.release
    version = release_info.version
    version_str = release.tag_name
    name = f"linux-hardened-{version_str}"

    old_version: Optional[list[int|str]] = None
    old_version_str: Optional[str] = None
    update: bool
    try:
        old_filename = patch_json[str(kernel_key)]["patch"]["name"]
        old_version_str = old_filename.replace("linux-hardened-", "").replace(
            ".patch", ""
        )
        old_version = normalize_kernel_version(old_version_str)
        update = old_version < version
    except KeyError:
        update = True

    if update:
        patch = fetch_patch(name=name, release_info=release_info)
        if patch is None:
            failures = True
        else:
            if str(kernel_key) in patch_json:
                message = f"{old_version_str} -> {version_str}"
            else:
                message = f"init at {version_str}"
            patch_json[str(kernel_key)] = patch

            commit_patches(kernel_key=kernel_key, message=message)

if removals:
    print("Hardened kernels were removed. Don't forget to remove their attributes!")

if failures:
    sys.exit(1)
