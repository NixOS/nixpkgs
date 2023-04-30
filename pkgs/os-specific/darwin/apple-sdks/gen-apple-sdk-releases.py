#!/usr/bin/env nix-shell
#!nix-shell -i python -p python3 nix bash xar

import re
import urllib.request
import dataclasses
from dataclasses import dataclass
from typing import DefaultDict, Literal, get_args
import logging
import subprocess
import json

logging.basicConfig(
    level=logging.DEBUG,
    datefmt="%Y-%m-%dT%H:%M:%S%z",
    format="[%(asctime)s][%(levelname)s] %(message)s",
)

logger = logging.getLogger(__name__)

SUCATALOG_URL = "https://swscan.apple.com/content/catalogs/others/index-13-12-10.16-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog"

# Packages we're interested in
PackageName = Literal[
    "CLTools_Executables",
    "CLTools_macOS_SDK",
    "CLTools_macOSLMOS_SDK",
    "CLTools_macOSNMOS_SDK",
]


class EnhancedJSONEncoder(json.JSONEncoder):
    def default(self, o):
        if dataclasses.is_dataclass(o):
            return dataclasses.asdict(o)
        return super().default(o)


@dataclass
class SuCatalogPackage:
    url: str
    hash: str
    package_name: PackageName


@dataclass
class NixStoreEntry:
    store_path: str
    hash: str


@dataclass
class FetchurlArgs:
    url: str
    hash: str


ParsedSuCatalog = dict[str, dict[PackageName, SuCatalogPackage]]
AppleSDKReleases = dict[str, dict[PackageName, FetchurlArgs]]


def parse_sucatalog(
    catalog_url: str,
) -> ParsedSuCatalog:
    logger.info(f"Fetching catalog from {catalog_url}...")
    with urllib.request.urlopen(catalog_url) as sucatalog:
        logger.info("Reading catalog...")
        text = sucatalog.read().decode("utf-8")

        logger.info("Searching catalog for packages...")
        catalog: ParsedSuCatalog = DefaultDict(dict)

        pat = re.compile(
            r"<string>(?P<url>https://swcdn\.apple\.com/content/downloads/.+/(?P<hash>.+)/(?P<package_name>"
            + "|".join(get_args(PackageName))
            + r")\.pkg)</string>",
            re.VERBOSE,
        )

        matches = pat.finditer(text)
        for match in matches:
            package = SuCatalogPackage(**match.groupdict())  # type: ignore
            logger.info(f"Found {package.package_name} with hash {package.hash}")
            catalog[package.hash][package.package_name] = package

        return catalog


def nix_prefetch_file(url: str) -> NixStoreEntry:
    logger.info(f"Adding {url} to Nix store...")
    result = subprocess.run(
        ["nix", "store", "prefetch-file", "--json", url],
        capture_output=True,
        text=True,
    )

    parsed = json.loads(result.stdout)
    store_entry = NixStoreEntry(store_path=parsed["storePath"], hash=parsed["hash"])
    logger.info(f"Stored at {store_entry.store_path} with hash {store_entry.hash}")

    return store_entry


def get_macOS_SDK_version(store_path: str) -> str:
    # Extract the Bom file from the package
    logger.info(f"Getting macOS SDK version from {store_path}")
    xar = subprocess.run(
        [
            "xar",
            "--exclude",
            "[^Bom]",
            "--to-stdout",
            "-xf",
            store_path,
        ],
        capture_output=True,
        text=False,
    )

    # Extract the SDK version from the Bom file
    pat = re.compile(r"MacOSX(?P<sdk_version>[\d.]+)\.sdk")
    matched = pat.search(str(xar.stdout))
    assert matched is not None, "Could not find SDK version"
    sdk_version = matched.groups("sdk_version")[0]

    # Make sure the version is 3 components long
    components = sdk_version.split(".")
    length_corrected = components + ["0"] * (3 - len(components))
    formatted = ".".join(length_corrected)
    return formatted


def generate_apple_sdk_releases(catalog: ParsedSuCatalog) -> AppleSDKReleases:
    apple_sdk_releases: AppleSDKReleases = DefaultDict(dict)
    for hash, packages in catalog.items():
        # Get CLTools_macOS_SDK since it'll have the SDK version
        macOS_SDK = packages.pop("CLTools_macOS_SDK")
        store_entry = nix_prefetch_file(macOS_SDK.url)
        sdk_version = get_macOS_SDK_version(store_entry.store_path)
        logger.info(f"Found macOS SDK version {sdk_version} for {hash}")

        # Warn if we have duplicate packages for the same SDK version
        if sdk_version in apple_sdk_releases:
            logger.warning(
                f"Found macOS SDK version {sdk_version}, but with {hash}!"
                " Will overwrite existing entries!"
            )

        fetchurl_args = FetchurlArgs(url=macOS_SDK.url, hash=store_entry.hash)
        apple_sdk_releases[sdk_version]["CLTools_macOS_SDK"] = fetchurl_args
        logger.info(
            f"Added CLTools_macOS_SDK for {sdk_version} from {hash} to releases"
        )

        for package_name, package in packages.items():
            if package_name in apple_sdk_releases[sdk_version]:
                logger.warning(
                    f"Replacing existing macOS SDK {sdk_version} {package_name} with"
                    f" package of the same version and name from {hash}"
                )
            store_entry = nix_prefetch_file(package.url)
            fetchurl_args = FetchurlArgs(url=package.url, hash=store_entry.hash)
            apple_sdk_releases[sdk_version][package_name] = fetchurl_args
            logger.info(
                f"Added {package_name} for {sdk_version} from {hash} to releases"
            )

    return apple_sdk_releases


if __name__ == "__main__":
    catalog = parse_sucatalog(SUCATALOG_URL)
    releases = generate_apple_sdk_releases(catalog)
    print(json.dumps(releases, indent=4, sort_keys=True, cls=EnhancedJSONEncoder))
