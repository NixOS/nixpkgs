#!/usr/bin/env nix-shell
#! nix-shell -i python -p "python3.withPackages (ps: with ps; [ps.requests ])"

import os
import hashlib
import base64
import json

import requests

HEADER = "User-Agent: nixpkgs/1.0.0 https://github.com/nixos/nixpkgs"


class Version:
    def __init__(self, name: str):
        self.name: str = name
        self.hash: str | None = None
        self.build_number: int | None = None

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
        response = requests.get(url, HEADER)

        try:
            response.raise_for_status()

        except requests.exceptions.HTTPError as e:
            print(e)
            return


        release_versions = response.json()["versions"][::-1]

        for version_name in release_versions:
            version_id = version_name["version"]["id"]

        # we only want versions that are no pre-releases
            if ("pre" in version_id) or ("rc" in version_id):
                continue

            # split version string, convert to list ot int
            version_split = version_id.split(".")
            version_split = list(map(int, version_split))

            # check if version is higher than 1.<not_before_sub_version>
            if (version_split[0] > 1) or (version_split[0] == 1 and version_split[1] >= not_before_minor_version):
                self.versions.append(Version(version_id))

    def fetch_latest_version_builds(self):
        """
        Set latest build number to each version
        """

        for version in self.versions:
            url = f"{self.base_url}/versions/{version.name}/builds/latest"
            response = requests.get(url, HEADER)

            # check that we've got a good response
            try:
                response.raise_for_status()

            except requests.exceptions.HTTPError as e:
                print(e)
                return

            # the latest build in from the api
            latest_build = response.json()['id']
            version.build_number = latest_build

    def generate_version_hashes(self):
        """
        Fetch and set the hashes for all registered versions (versions are downloaded to memory)
        """

        print("Fetching version hashes")
        for version in self.versions:
            version.build_number
            url = f"{self.base_url}/versions/{version.name}/builds/{version.build_number}"
            response = requests.get(url, HEADER)

            # check that we've got a good response
            try:
                response.raise_for_status()

            except requests.exceptions.HTTPError as e:
                print(e)
                return
            hex_hash = response.json()["downloads"]["server:default"]["checksums"]["sha256"]
            raw_bytes = bytes.fromhex(hex_hash)

            base64_encoded = base64.b64encode(raw_bytes).decode('utf-8')

            version.hash  = f"sha256-{base64_encoded}"


    def versions_to_json(self):
        return json.dumps(
            {version.name: {'hash': version.hash, 'version': version.full_name}
                for version in self.versions},
            indent=4
        )

    @staticmethod
    def find_version_json() -> str:
        """
        Find the versions.json file in the same directory as this script
        """
        return os.path.join(os.path.dirname(os.path.realpath(__file__)), "versions.json")

    def write_versions(self, file_name: str = find_version_json()):
        """ write all processed versions to json """
        # save json to versions.json
        with open(file_name, 'w') as f:
            f.write(self.versions_to_json() + "\n")



if __name__ == '__main__':
    version_manager = VersionManager()

    version_manager.fetch_versions()
    version_manager.fetch_latest_version_builds()
    version_manager.generate_version_hashes()
    version_manager.write_versions()
