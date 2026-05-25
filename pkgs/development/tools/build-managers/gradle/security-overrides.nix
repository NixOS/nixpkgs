# Transparent security upgrades for known-vulnerable Maven artifact versions.
#
# Every entry here is merged into the overrides passed to mitm-cache.fetch for
# ALL Gradle builds that use gradle.fetchDeps. When Gradle requests a listed
# vulnerable version the MITM proxy silently serves the patched jar instead,
# with no changes required to the consuming package.
#
# HOW TO ADD AN ENTRY
# -------------------
# Use mkVersionChainUpgrade (re-exported as gradle.mkVersionChainUpgrade):
#
#   (mkVersionChainUpgrade {
#     groupId     = "commons-codec";
#     artifactId  = "commons-codec";
#     oldVersions = [ "1.0" "1.1" "1.2" "1.3" "1.4" "1.5" "1.6"
#                     "1.7" "1.8" "1.9" "1.10" "1.11" "1.12" ];
#     jar = fetchurl {
#       url  = "https://repo.maven.apache.org/maven2/commons-codec/commons-codec/1.13/commons-codec-1.13.jar";
#       hash = "sha256-<run: nix-prefetch-url --type sha256 <url>>";
#     };
#   })
#
# Add the entry to the list below and open a PR that includes:
#   - the CVE / advisory reference
#   - the first safe version
#   - the hash of the replacement jar (verified with nix-prefetch-url)
#
# KNOWN CANDIDATES (hashes still need to be pinned before adding)
# ---------------------------------------------------------------
#   commons-codec < 1.13      WS-2019-0379
#   gson < 2.8.9              CVE-2022-25647  (com.google.code.gson:gson)
#   slf4j-api 1.x < 1.7.36   several low-severity issues
#
{
  lib,
  fetchurl,
  mkVersionChainUpgrade,
}:

lib.mergeAttrsList [
  # Add entries here, one mkVersionChainUpgrade call per vulnerable artifact.
]
