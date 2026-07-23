#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3 nix

import argparse
import json
import os
import re
import subprocess
import sys
from pathlib import Path
from urllib.request import Request, urlopen


GITHUB_RELEASES = (
    "https://api.github.com/repos/zen-kernel/zen-kernel/releases?per_page=100"
)
SOURCE_URL = "https://github.com/zen-kernel/zen-kernel/archive/refs/tags/{tag}.tar.gz"
PACKAGE_FILE = Path(__file__).with_name("liquorix-kernel.nix")
REPO_PACKAGE_FILE = "pkgs/os-specific/linux/kernel/liquorix-kernel.nix"
TAG_PATTERN = re.compile(
    r"^v(?P<version>[0-9]+\.[0-9]+(?:\.[0-9]+)?)-(?P<suffix>lqx(?P<revision>[0-9]+))$"
)

# This is deliberately an allowlist of Liquorix policy, not its full Debian
# hardware configuration. A changed value is a human-review event.
CONFIG_POLICY = {
    "CONFIG_CFS_BANDWIDTH": "y",
    "CONFIG_CMDLINE": '"audit=0 intel_pstate=disable amd_pstate=disable split_lock_detect=off "',
    "CONFIG_CMDLINE_BOOL": "y",
    "CONFIG_DEFAULT_BBR3": "y",
    "CONFIG_DEFAULT_FQ_CODEL": "y",
    "CONFIG_ENERGY_MODEL": "n",
    "CONFIG_FUTEX": "y",
    "CONFIG_FUTEX_PI": "y",
    "CONFIG_HZ": "1000",
    "CONFIG_HZ_1000": "y",
    "CONFIG_IOSCHED_BFQ": "y",
    "CONFIG_NET_SCH_DEFAULT": "y",
    "CONFIG_NO_HZ_FULL": "y",
    "CONFIG_NO_HZ_IDLE": "n",
    "CONFIG_NTSYNC": "y",
    "CONFIG_PREEMPT": "y",
    "CONFIG_PREEMPT_DYNAMIC": "n",
    "CONFIG_PREEMPT_LAZY": "n",
    "CONFIG_PSI": "y",
    "CONFIG_RCU_BOOST": "n",
    "CONFIG_RCU_LAZY": "n",
    "CONFIG_RCU_NOCB_CPU": "y",
    "CONFIG_RCU_NOCB_CPU_DEFAULT_ALL": "y",
    "CONFIG_RT_GROUP_SCHED": "y",
    "CONFIG_SCHED_ALT": "y",
    "CONFIG_SCHED_PDS": "y",
    "CONFIG_SLAB_BUCKETS": "y",
    "CONFIG_TCP_CONG_BBR3": "y",
    "CONFIG_WQ_POWER_EFFICIENT_DEFAULT": "y",
    "CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZ4": "y",
    "CONFIG_ZSWAP_COMPRESSOR_DEFAULT_ZSTD": "n",
    "CONFIG_ZEN_INTERACTIVE": "y",
}


def fetch_json(url):
    request = Request(
        url,
        headers={
            "Accept": "application/vnd.github+json",
            "User-Agent": "nixpkgs-liquorix-updater",
        },
    )
    with urlopen(request) as response:
        return json.load(response)


def parse_tag(tag):
    match = TAG_PATTERN.fullmatch(tag)
    if match is None:
        return None
    version = match.group("version")
    suffix = match.group("suffix")
    version_key = tuple(int(component) for component in version.split("."))
    return {
        "tag": tag,
        "version": version,
        "suffix": suffix,
        "key": (version_key, int(match.group("revision"))),
    }


def select_latest_release(releases):
    candidates = []
    for release in releases:
        if release.get("draft") or release.get("prerelease"):
            continue
        parsed = parse_tag(release.get("tag_name", ""))
        if parsed is not None:
            candidates.append(parsed)
    if not candidates:
        raise RuntimeError("GitHub returned no stable Liquorix releases")
    return max(candidates, key=lambda release: release["key"])


def read_package(path=PACKAGE_FILE):
    contents = path.read_text()
    version_match = re.search(r'^\s+version = "([^"]+)";$', contents, re.MULTILINE)
    suffix_match = re.search(r'^\s+suffix = "([^"]+)";$', contents, re.MULTILINE)
    if version_match is None or suffix_match is None:
        raise RuntimeError(f"could not read version and suffix from {path}")
    return contents, version_match.group(1), suffix_match.group(1)


def render_package(contents, version, suffix, sha256):
    replacements = (
        (r'^(\s+version = )"[^"]+";$', rf'\1"{version}";'),
        (r'^(\s+suffix = )"[^"]+";$', rf'\1"{suffix}";'),
        (r'^(\s+sha256 = )"[^"]+";$', rf'\1"{sha256}";'),
    )
    result = contents
    for pattern, replacement in replacements:
        result, count = re.subn(
            pattern, replacement, result, count=1, flags=re.MULTILINE
        )
        if count != 1:
            raise RuntimeError(f"expected one match for {pattern}, found {count}")
    return result


def prefetch(tag):
    print(f"prefetching {tag}", file=sys.stderr)
    return subprocess.check_output(
        ["nix-prefetch-url", "--unpack", SOURCE_URL.format(tag=tag)],
        text=True,
    ).strip()


def fetch_text(url):
    request = Request(url, headers={"User-Agent": "nixpkgs-liquorix-updater"})
    with urlopen(request) as response:
        return response.read().decode()


def parse_kernel_config(contents):
    result = {}
    for line in contents.splitlines():
        enabled = re.fullmatch(r"(CONFIG_[A-Z0-9_]+)=(.*)", line)
        disabled = re.fullmatch(r"# (CONFIG_[A-Z0-9_]+) is not set", line)
        if enabled:
            result[enabled.group(1)] = enabled.group(2)
        elif disabled:
            result[disabled.group(1)] = "n"
    return result


def config_report(version, config_text=None):
    branch = ".".join(version.split(".")[:2]) + "/master"
    url = (
        "https://raw.githubusercontent.com/damentz/liquorix-package/"
        f"{branch}/linux-liquorix/debian/config/kernelarch-x86/config-arch-64"
    )
    upstream = parse_kernel_config(
        config_text if config_text is not None else fetch_text(url)
    )
    actual = {key: upstream.get(key, "missing") for key in CONFIG_POLICY}
    drift = {
        key: {"expected": expected, "actual": actual[key]}
        for key, expected in CONFIG_POLICY.items()
        if actual[key] != expected
    }
    return {"branch": branch, "url": url, "values": actual, "drift": drift}


def load_releases(path):
    if path is not None:
        return json.loads(path.read_text())
    return fetch_json(GITHUB_RELEASES)


def main():
    parser = argparse.ArgumentParser(description="Update the Nixpkgs Liquorix kernel")
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument(
        "--check", action="store_true", help="report without changing files"
    )
    mode.add_argument(
        "--config-report",
        action="store_true",
        help="compare the tracked Liquorix policy with its upstream configuration",
    )
    parser.add_argument(
        "--release-json",
        type=Path,
        help="read GitHub release data from a fixture instead of the network",
    )
    args = parser.parse_args()

    release = select_latest_release(load_releases(args.release_json))
    contents, old_version, old_suffix = read_package()
    current = old_version == release["version"] and old_suffix == release["suffix"]

    if args.config_report:
        report = config_report(release["version"])
        json.dump(report, sys.stdout, indent=2, sort_keys=True)
        print()
        return 1 if report["drift"] else 0

    if args.check:
        json.dump(
            {
                "current": current,
                "oldVersion": old_version,
                "oldSuffix": old_suffix,
                "newVersion": release["version"],
                "newSuffix": release["suffix"],
                "tag": release["tag"],
            },
            sys.stdout,
            sort_keys=True,
        )
        print()
        return 0

    if current:
        print("[]")
        return 0

    sha256 = prefetch(release["tag"])
    PACKAGE_FILE.write_text(
        render_package(contents, release["version"], release["suffix"], sha256)
    )
    change = {
        "attrPath": os.environ.get("UPDATE_NIX_ATTR_PATH", "linux_lqx"),
        "oldVersion": old_version,
        "newVersion": release["version"],
        "files": [REPO_PACKAGE_FILE],
        "commitBody": (
            f"- Release: https://github.com/zen-kernel/zen-kernel/releases/tag/{release['tag']}\n"
            f"- Compare: https://github.com/zen-kernel/zen-kernel/compare/"
            f"v{old_version}-{old_suffix}...{release['tag']}"
        ),
    }
    print(json.dumps([change]))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
