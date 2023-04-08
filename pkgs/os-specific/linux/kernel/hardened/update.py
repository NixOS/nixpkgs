#! /usr/bin/env nix-shell
#! nix-shell -i python -p "python3.withPackages (ps: [ps.pygithub])" git gnupg

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

VersionComponent = Union[int, str]
Version = List[VersionComponent]


PatchData = TypedDict("PatchData", {"name": str, "url": str, "sha256": str, "extra": str})
Patch = TypedDict("Patch", {
    "patch": PatchData,
    "version": str,
    "sha256": str,
})


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
MIN_KERNEL_VERSION: Version = [4, 14]


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

    kernel_ver = re.sub(r"(.*)(-hardened[\d]+)$", r'\1', release_info.release.tag_name)
    major = kernel_ver.split('.')[0]
    sha256_kernel, _ = nix_prefetch_url(f"mirror://kernel/linux/kernel/v{major}.x/linux-{kernel_ver}.tar.xz")

    return Patch(
        patch=PatchData(name=patch_filename, url=patch_url, sha256=sha256, extra=extra),
        version=kernel_ver,
        sha256=sha256_kernel
    )


def parse_version(version_str: str) -> Version:
    version: Version = []
    for component in re.split('\.|\-', version_str):
        try:
            version.append(int(component))
        except ValueError:
            version.append(component)
    return version


def version_string(version: Version) -> str:
    return ".".join(str(component) for component in version)


def major_kernel_version_key(kernel_version: Version) -> str:
    return version_string(kernel_version[:-1])


def commit_patches(*, kernel_key: str, message: str) -> None:
    new_patches_path = HARDENED_PATCHES_PATH.with_suffix(".new")
    with open(new_patches_path, "w") as new_patches_file:
        json.dump(patches, new_patches_file, indent=4, sort_keys=True)
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
patches: Dict[str, Patch]
with open(HARDENED_PATCHES_PATH) as patches_file:
    patches = json.load(patches_file)

# Get the set of currently packaged kernel versions.
kernel_versions = {}
for filename in os.listdir(NIXPKGS_KERNEL_PATH):
    filename_match = re.fullmatch(r"linux-(\d+)\.(\d+)\.nix", filename)
    if filename_match:
        nix_version_expr = f"""
            with import {NIXPKGS_PATH} {{}};
            (callPackage {NIXPKGS_KERNEL_PATH / filename} {{}}).version
        """
        kernel_version_json = run(
            "nix-instantiate", "--eval", "--system", "x86_64-linux", "--json", "--expr", nix_version_expr,
        ).stdout
        kernel_version = parse_version(json.loads(kernel_version_json))
        if kernel_version < MIN_KERNEL_VERSION:
            continue
        kernel_key = major_kernel_version_key(kernel_version)
        kernel_versions[kernel_key] = kernel_version

# Remove patches for unpackaged kernel versions.
for kernel_key in sorted(patches.keys() - kernel_versions.keys()):
    commit_patches(kernel_key=kernel_key, message="remove")

g = Github(os.environ.get("GITHUB_TOKEN"))
repo = g.get_repo(HARDENED_GITHUB_REPO)
failures = False

# Match each kernel version with the best patch version.
releases = {}
i = 0
for release in repo.get_releases():
    # Dirty workaround to make sure that we don't run into issues because
    # GitHub's API only allows fetching the last 1000 releases.
    # It's not reliable to exit earlier because not every kernel minor may
    # have hardened patches, hence the naive search below.
    i += 1
    if i > 500:
        break

    version = parse_version(release.tag_name)
    # needs to look like e.g. 5.6.3-hardened1
    if len(version) < 4:
        continue

    if not (isinstance(version[-2], int)):
        continue

    kernel_version = version[:-1]

    kernel_key = major_kernel_version_key(kernel_version)
    try:
        packaged_kernel_version = kernel_versions[kernel_key]
    except KeyError:
        continue

    release_info = ReleaseInfo(version=version, release=release)

    if kernel_version == packaged_kernel_version:
        releases[kernel_key] = release_info
    else:
        # Fall back to the latest patch for this major kernel version,
        # skipping patches for kernels newer than the packaged one.
        if '.'.join(str(x) for x in kernel_version) > '.'.join(str(x) for x in packaged_kernel_version):
            continue
        elif (
            kernel_key not in releases or releases[kernel_key].version < version
        ):
            releases[kernel_key] = release_info

# Update hardened-patches.json for each release.
for kernel_key in sorted(releases.keys()):
    release_info = releases[kernel_key]
    release = release_info.release
    version = release_info.version
    version_str = release.tag_name
    name = f"linux-hardened-{version_str}"

    old_version: Optional[Version] = None
    old_version_str: Optional[str] = None
    update: bool
    try:
        old_filename = patches[kernel_key]["patch"]["name"]
        old_version_str = old_filename.replace("linux-hardened-", "").replace(
            ".patch", ""
        )
        old_version = parse_version(old_version_str)
        update = old_version < version
    except KeyError:
        update = True

    if update:
        patch = fetch_patch(name=name, release_info=release_info)
        if patch is None:
            failures = True
        else:
            patches[kernel_key] = patch
            if old_version:
                message = f"{old_version_str} -> {version_str}"
            else:
                message = f"init at {version_str}"
            commit_patches(kernel_key=kernel_key, message=message)

missing_kernel_versions = kernel_versions.keys() - patches.keys()

if missing_kernel_versions:
    print(
        f"warning: no patches for kernel versions "
        + ", ".join(missing_kernel_versions),
        file=sys.stderr,
    )

if failures:
    sys.exit(1)
