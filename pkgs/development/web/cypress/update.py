#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3 python3.pkgs.requests unzip

import json
import logging
import pathlib
import requests
import subprocess
import sys
import tempfile

updates_url = "https://cdn.cypress.io/desktop/"
packages_file_path = pathlib.Path(__file__).parent.joinpath("packages.json").resolve()
platform_names = {"darwin", "linux"}

logging.basicConfig(stream=sys.stdout, level=logging.DEBUG)


def download_packages_info():
    logging.info("Checking for updates from %s", updates_url)
    updates_response = requests.get(updates_url)
    updates_response.raise_for_status()
    return updates_response.json()


def check_version(versions):
    if packages_file_path.is_file():
        with open(packages_file_path, "r") as packages_file:
            old_packages = json.load(packages_file)
            if old_packages["version"] == versions["version"]:
                logging.info("Current version %s is the latest", versions["version"])
                sys.exit()


def calculate_sha256(platform, package):
    url = package["url"]
    logging.info("Calculating SHA-256 for %s", url)
    if platform == "darwin":
        # nix-prefetch-url does not work when using fetchzip with stripRoot = false.
        result = subprocess.run(["nix-prefetch-url", url, "--print-path"], capture_output=True, check=True, text=True)
        zip_path = result.stdout.splitlines()[-1]
        with tempfile.TemporaryDirectory() as temp_dir:
            subprocess.run(["unzip", zip_path, "-d", temp_dir], check=True)
            result = subprocess.run(["nix-hash", temp_dir, "--type", "sha256", "--base32"], capture_output=True, check=True, text=True)
    else:
        result = subprocess.run(["nix-prefetch-url", url, "--unpack"], capture_output=True, check=True, text=True)
    return result.stdout.strip()


def write_packages(packages):
    with open(packages_file_path, "w") as packages_file:
        json.dump(packages, packages_file, indent=2)
        packages_file.write("\n")


packages = download_packages_info()
check_version(packages)

package_sources = {
    platform: package | { "sha256": calculate_sha256(platform, package) }
    for (platform, package)
    in packages["packages"].items()
    if platform in platform_names
}
packages["packages"] = package_sources

write_packages(packages)
