#!/usr/bin/env nix-shell
#!nix-shell -i python3 --packages python3 nix nix-update nixfmt jujutsu git
# ruff: noqa: EXE005

import argparse
import json
import re
import shutil
import subprocess
from datetime import UTC, date, datetime, timedelta
from pathlib import Path
from urllib.request import Request, urlopen

ROOT = Path(__file__).resolve().parents[3]
PACKAGE_DIR = ROOT / "pkgs/servers/kanidm"
ALL_PACKAGES = ROOT / "pkgs/top-level/all-packages.nix"
HYDRA_RELEASE = ROOT / "pkgs/top-level/release.nix"
ALIASES = ROOT / "pkgs/top-level/aliases.nix"


def run(*command):
    subprocess.run(command, cwd=ROOT, check=True)


def format_nix(*paths):
    run("nixfmt", *(str(path) for path in paths))


def commit_phase(args, message, *paths):
    if not args.commit:
        print(f"Commit separately:\n{message}")
        return
    files = [str(path.relative_to(ROOT)) for path in paths]
    if (ROOT / ".jj").is_dir():
        run("jj", "commit", "--message", message, *files)
    else:
        run("git", "add", "--", *files)
        run("git", "commit", "--only", "--message", message, "--", *files)
    print(f"Committed: {message.splitlines()[0]}.")


def github_json(endpoint):
    request = Request(
        f"https://api.github.com/repos/kanidm/kanidm/releases{endpoint}",
        headers={
            "Accept": "application/vnd.github+json",
            "User-Agent": "nixpkgs-kanidm-release",
        },
    )
    with urlopen(request) as response:
        return json.load(response)


def release_info(release):
    releases = github_json("?per_page=10")
    versions = [
        item["tag_name"].removeprefix("v")
        for item in releases
        if not item["draft"]
        and not item["prerelease"]
        and re.fullmatch(
            rf"{re.escape(release)}\.[0-9]+",
            item["tag_name"].removeprefix("v"),
        )
    ]
    if not versions:
        raise ValueError(
            f"No {release}.x release found in the ten latest GitHub releases"
        )
    version = max(versions, key=lambda value: int(value.rsplit(".", 1)[1]))
    initial = github_json(f"/tags/v{release}.0")
    return version, date.fromisoformat(initial["published_at"][:10])


def replace_once(text, old, new):
    if text.count(old) != 1:
        raise ValueError(f"Expected one occurrence of {old!r}")
    return text.replace(old, new, 1)


def set_assignment(path, name, value):
    text = path.read_text()
    pattern = rf"(?m)^  {name} = [^\n]+;\n"
    assignment = f"  {name} = {value};\n"
    if re.search(pattern, text):
        text = re.sub(pattern, assignment, text)
    else:
        text = replace_once(text, "\n}", f"\n{assignment}}}")
    path.write_text(text)


def version_key(version):
    return "_".join(version.split(".")[:2])


def bindings(key):
    return (
        (
            f"      kanidm_{key} = callPackage ../servers/kanidm/{key}.nix {{\n"
            f"        kanidmWithSecretProvisioning = kanidmWithSecretProvisioning_{key};\n"
            "      };\n"
        ),
        f"      kanidmWithSecretProvisioning_{key} = kanidm_{key}.override {{ enableSecretProvisioning = true; }};\n",
        f"    kanidm_{key}\n",
        f"    kanidmWithSecretProvisioning_{key}\n",
    )


def package_info(key):
    expression = f"(import ./. {{ config.allowInsecure = true; }}).kanidm_{key}.version"
    result = subprocess.run(
        ["nix", "eval", "--impure", "--json", "--expr", expression],
        cwd=ROOT,
        check=True,
        capture_output=True,
        text=True,
    )
    version = json.loads(result.stdout)
    return {
        "version": version,
        "names": [
            f"kanidm_{key}-{version}",
            f"kanidmWithSecretProvisioning_{key}-{version}",
        ],
    }


def without_allowlist_entries(text, key, info):
    names = [
        f"kanidm_{key}-{info['version']}",
        f"kanidmWithSecretProvisioning_{key}-{info['version']}",
    ]
    for name in names:
        text = re.sub(rf'(?m)^        "{re.escape(name)}"\n', "", text)
    return text


def new_release(args):
    previous = max(
        (path.stem for path in PACKAGE_DIR.glob("[0-9]*_[0-9]*.nix")),
        key=lambda key: tuple(map(int, key.split("_"))),
    )
    key = version_key(args.release)
    source = PACKAGE_DIR / f"{previous}.nix"
    target = PACKAGE_DIR / f"{key}.nix"
    if key == previous or target.exists():
        raise ValueError(f"Release {key} already exists")
    version, published_date = release_info(args.release)

    text = re.sub(r"(?m)^  (?:unsupported|eolDate) = [^\n]+;\n", "", source.read_text())
    shutil.copytree(
        PACKAGE_DIR / "provision-patches" / previous,
        PACKAGE_DIR / "provision-patches" / key,
    )
    target.write_text(text)

    text = ALL_PACKAGES.read_text()
    for old, new in zip(bindings(previous), bindings(key)):
        text = replace_once(text, old, old + new)
    ALL_PACKAGES.write_text(text)

    run(
        "nix-update",
        f"kanidm_{key}",
        "--version",
        version,
        "--override-filename",
        str(target.relative_to(ROOT)),
    )

    eol_date = published_date + timedelta(days=30)
    set_assignment(source, "eolDate", json.dumps(eol_date.isoformat()))
    tests = []
    for filename, attribute in (
        ("kanidm.nix", "kanidm"),
        ("kanidm-provisioning.nix", "kanidmWithSecretProvisioning"),
    ):
        path = ROOT / "nixos/tests" / filename
        text = path.read_text()
        old = re.search(
            rf"_module\.args\.kanidmPackage = pkgs\.lib\.mkDefault pkgs\.{attribute}_[0-9]+_[0-9]+;",
            text,
        ).group(0)
        new = f"_module.args.kanidmPackage = pkgs.lib.mkDefault pkgs.{attribute}_{key};"
        path.write_text(replace_once(text, old, new))
        tests.append(path)
    format_nix(target, source, ALL_PACKAGES, *tests)

    print(f"Prepared kanidm_{key} at {version}; predecessor EOL: {eol_date}.")
    print(
        "Review provisioning patches and generic.nix, then build both packages and their passthru.tests."
    )
    commit_phase(
        args,
        (
            f"kanidm_{key}: init at {version}\n\n"
            f"Changelog: https://github.com/kanidm/kanidm/releases/tag/v{version}"
        ),
        target,
        PACKAGE_DIR / "provision-patches" / key,
        source,
        ALL_PACKAGES,
        *tests,
    )


def mark_unsupported(args):
    key = version_key(args.release)
    info = package_info(key)
    path = PACKAGE_DIR / f"{key}.nix"
    set_assignment(path, "unsupported", "true")
    text = HYDRA_RELEASE.read_text()
    anchor = "      permittedInsecurePackages = [\n"
    entries = "".join(
        f'        "{name}"\n' for name in info["names"] if f'"{name}"' not in text
    )
    HYDRA_RELEASE.write_text(replace_once(text, anchor, anchor + entries))
    format_nix(path, HYDRA_RELEASE)
    print(f"Marked kanidm_{key} unsupported and permitted both derivations for Hydra.")
    commit_phase(args, f"kanidm_{key}: mark EOL", path, HYDRA_RELEASE)
    print("Backport the EOL commit.")


def alias_sort_key(name):
    return [
        int(part) if part.isdigit() else part.lower()
        for part in re.split(r"([0-9]+)", name)
    ]


def remove_release(args):
    key = version_key(args.release)
    info = package_info(key)
    for filename, attribute in (
        ("kanidm.nix", "kanidm"),
        ("kanidm-provisioning.nix", "kanidmWithSecretProvisioning"),
    ):
        text = (ROOT / "nixos/tests" / filename).read_text()
        if f"pkgs.{attribute}_{key};" in text:
            raise ValueError(f"Release {key} is still the default in {filename}")

    text = ALL_PACKAGES.read_text()
    for binding in bindings(key):
        text = replace_once(text, binding, "")
    ALL_PACKAGES.write_text(text)
    HYDRA_RELEASE.write_text(
        without_allowlist_entries(HYDRA_RELEASE.read_text(), key, info)
    )
    (PACKAGE_DIR / f"{key}.nix").unlink()
    shutil.rmtree(PACKAGE_DIR / "provision-patches" / key)
    text = ALIASES.read_text()
    for attribute in ("kanidm", "kanidmWithSecretProvisioning"):
        name = f"{attribute}_{key}"
        alias = (
            f"  {name} = throw \"'{name}' has been removed as it has reached end of life\";"
            f" # Added {datetime.now(UTC).date().isoformat()}\n"
        )
        aliases = list(
            re.finditer(
                r"(?m)^  (kanidm(?:WithSecretProvisioning)?(?:_[0-9]+_[0-9]+)?)"
                r" = [^\n]*\n",
                text,
            )
        )
        sort_key = alias_sort_key(name)
        position = next(
            (
                match.start()
                for match in aliases
                if alias_sort_key(match.group(1)) > sort_key
            ),
            aliases[-1].end(),
        )
        text = text[:position] + alias + text[position:]
    ALIASES.write_text(text)
    format_nix(ALL_PACKAGES, HYDRA_RELEASE, ALIASES)
    print(f"Removed kanidm_{key}, its provisioning variant, and provisioning patches.")
    commit_phase(
        args,
        f"kanidm_{key}: remove EOL release",
        ALL_PACKAGES,
        HYDRA_RELEASE,
        ALIASES,
        PACKAGE_DIR / f"{key}.nix",
        PACKAGE_DIR / "provision-patches" / key,
    )
    print("Do not backport the cleanup commit.")


def minor_release(value):
    if not re.fullmatch(r"[0-9]+\.[0-9]+", value):
        raise argparse.ArgumentTypeError("Expected a release such as 1.11")
    return value


def main():
    parser = argparse.ArgumentParser(
        description="Execute Kanidm packaging release phases."
    )
    phases = parser.add_subparsers(dest="phase", required=True)
    new = phases.add_parser(
        "new-release", help="Add a release and schedule predecessor EOL"
    )
    new.add_argument("release", type=minor_release)
    new.add_argument(
        "--commit", action="store_true", help="Commit this phase's changes"
    )
    new.set_defaults(action=new_release)
    unsupported = phases.add_parser(
        "mark-unsupported", help="Mark EOL and permit Hydra builds"
    )
    unsupported.add_argument("release", type=minor_release)
    unsupported.add_argument(
        "--commit", action="store_true", help="Commit this phase's changes"
    )
    unsupported.set_defaults(action=mark_unsupported)
    remove = phases.add_parser(
        "remove-release", help="Remove an obsolete release from master"
    )
    remove.add_argument("release", type=minor_release)
    remove.add_argument(
        "--commit", action="store_true", help="Commit this phase's changes"
    )
    remove.set_defaults(action=remove_release)
    args = parser.parse_args()
    args.action(args)


if __name__ == "__main__":
    main()
