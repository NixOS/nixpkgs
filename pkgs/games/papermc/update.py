#!/usr/bin/env nix-shell
#! nix-shell -i python -p "python3.withPackages (ps: with ps; [ps.requests ])"

import base64
import json
import os
import re
from pathlib import Path
from typing import Any

import requests

HEADERS = {"User-Agent": "nixpkgs/1.0.0 https://github.com/nixos/nixpkgs"}


class Version:
    def __init__(self, name: str):
        self.name: str = name
        self.hash: str | None = None
        self.build_number: int | None = None
        self.url: str | None = None
        self.java_version: int | None = None

    @property
    def full_name(self):
        v_name = f"{self.name}-{self.build_number}"

        # this will probably never happen because the download of a build with NoneType in URL would fail
        if not self.name or not self.build_number:
            print(f"Warning: version '{v_name}' contains NoneType!")

        return v_name


class VersionManager:
    def __init__(self, base_url: str = "https://fill.papermc.io/v3/projects/paper"):
        self.versions: list[Version] = []
        self.base_url: str = base_url

    def fetch_versions(self, not_before_minor_version: int = 18):
        """
        Fetch all versions after given minor release
        """

        url = f"{self.base_url}/versions"
        response = requests.get(url, headers=HEADERS)

        try:
            response.raise_for_status()

        except requests.exceptions.HTTPError as e:
            print(e)
            return

        release_versions = response.json()["versions"]

        for version_name in release_versions:
            version_id = version_name["version"]["id"]

            # we only want versions that are not pre-releases
            if ("pre" in version_id) or ("rc" in version_id):
                continue

            # split version string, convert to list ot int
            version_split = version_id.split(".")
            version_split = list(map(int, version_split))

            # check if version is higher than 1.<not_before_sub_version>
            if (version_split[0] > 1) or (
                version_split[0] == 1 and version_split[1] >= not_before_minor_version
            ):
                self.versions.append(Version(version_id))

    def fetch_latest_version_builds(self):
        """
        Set latest build number to each version
        """

        for version in self.versions:
            body = self.fetch_latest_build(version.name)

            # the latest build from the api
            latest_build = body["id"]
            version.build_number = latest_build

            version.java_version = self.fetch_java_version(version.name)

            # Grab the url from the api
            download_info = body["downloads"]["server:default"]
            version.url = download_info["url"]

            hex_hash = download_info["checksums"]["sha256"]
            raw_bytes = bytes.fromhex(hex_hash)

            base64_encoded = base64.b64encode(raw_bytes).decode("utf-8")

            version.hash = f"sha256-{base64_encoded}"

    def fetch_latest_build(self, name: str) -> dict[str, Any]:
        url = f"{self.base_url}/versions/{name}/builds/latest"
        response = requests.get(url, headers=HEADERS)

        # check that we've got a good response
        try:
            response.raise_for_status()
            return response.json()
        except requests.exceptions.HTTPError as e:
            print(e)
            return {}

    def fetch_java_version(self, name: str):
        url = f"{self.base_url}/versions/{name}"
        response = requests.get(url, headers=HEADERS)

        # check that we've got a good response
        try:
            response.raise_for_status()
            return response.json()["version"]["java"]["version"]["minimum"]
        except requests.exceptions.HTTPError as e:
            print(e)
            return

    def generate_version_hashes(self):
        """
        Fetch and set the hashes for all registered versions (versions are downloaded to memory)
        """

        print("Fetching version hashes")
        for version in self.versions:
            url = (
                f"{self.base_url}/versions/{version.name}/builds/{version.build_number}"
            )
            response = requests.get(url, headers=HEADERS)

            # check that we've got a good response
            try:
                response.raise_for_status()

            except requests.exceptions.HTTPError as e:
                print(e)
                return

    def versions_to_dict(self) -> dict[str, Any]:
        return {
            version.name: {
                "hash": version.hash,
                "version": version.full_name,
                "url": version.url,
                "javaVersion": version.java_version,
            }
            for version in self.versions
        }

    def generate_version_dict(self) -> dict[str, Any]:
        self.fetch_versions()
        self.fetch_latest_version_builds()
        return self.versions_to_dict()

    @staticmethod
    def find_version_json() -> str:
        """
        Find the versions.json file in the same directory as this script
        """
        return os.path.join(
            os.path.dirname(os.path.realpath(__file__)), "versions.json"
        )


def get_latest(servers: dict[str, Any]) -> str | None:
    return max(
        (v.get("version") for v in servers.values()),
        key=lambda x: tuple(map(int, re.split("[\\.|-]", x))) if x is not None else (),
    )


def slugify(version: str) -> str:
    return version.replace(".", "_")


def generate_commit(
    previous_servers: dict[str, Any],
    servers: dict[str, Any],
    versions_file: Path,
) -> list[dict[str, str | list[str]]]:
    actions = []
    commit_body_lines = []

    old_latest = get_latest(previous_servers)
    new_latest = get_latest(servers)

    for major_version, server in servers.items():
        version = server.get("version")
        previous_server = previous_servers.get(major_version)

        if version is None:
            continue

        attribute = f"papermcServers.papermc-{slugify(major_version)}"

        if not previous_server:
            # this version didn't exist before
            # check if its now the latest version
            if version == new_latest:
                action = f"{old_latest} -> {new_latest}"
                attribute = "papermc"
            else:
                action = f"init {version}"

        else:
            previous_version = previous_server.get("version")
            if previous_version == version:
                continue

            action = f"{previous_version} -> {version}"

        actions.append(action)

        commit_body_lines.append(f"{attribute}: {action}")

    if not commit_body_lines:
        return []

    if len(actions) == 1:
        commit_message = commit_body_lines[0]

        # the body should only be the release notes to avoid repetition
        # if the release notes don't exist this will be blank
        commit_body = "\n".join(commit_body_lines[1:]).strip()
    else:
        detailed_message = f"papermc: {', '.join(actions)}"

        commit_message = (
            detailed_message
            if len(detailed_message) <= 72
            else "papermc: update multiple versions"
        )

    commit_body = "\n".join(commit_body_lines).strip()

    commit_json = {
        "attrPath": "papermcServers.papermc",
        "files": [str(versions_file)],
        "commitMessage": commit_message,
    }

    if commit_body:
        commit_json["commitBody"] = commit_body

    return [commit_json]


if __name__ == "__main__":
    versions_file = Path(__file__).parent / "versions.json"

    with open(versions_file, "r") as f:
        old_versions = json.load(f)

    version_manager = VersionManager()

    new_versions = version_manager.generate_version_dict()

    commit_json = generate_commit(old_versions, new_versions, versions_file)

    with open(versions_file, "w") as f:
        json.dump(new_versions, f, indent=4)
        f.write("\n")

    print(json.dumps(commit_json))
