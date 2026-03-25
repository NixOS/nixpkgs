import json
import re
import sys
import subprocess
import urllib.request

from typing import Iterable, Optional, Tuple
from urllib.request import urlopen
from datetime import datetime

# Number of spaces used for each indentation level
JSON_INDENT = 4

releases_json = None

# Releases that have reached end-of-life no longer receive any updates
# and it is rather pointless trying to update those.
#
# https://endoflife.date/electron
def supported_version_range() -> range:
    """Returns a range of electron releases that have not reached end-of-life yet"""
    global releases_json
    if releases_json is None:
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
