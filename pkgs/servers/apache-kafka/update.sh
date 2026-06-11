#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix

set -euo pipefail
echoerr() { echo "$@" 1>&2; }

fname="$1"
echoerr "Working on $fname"

# Extract series from filename: 4_1.nix → 4.1
series=$(basename "$fname" .nix | tr '_' '.')
echoerr "Series: $series"

# Read current values from the nix file.
current_kafka_version=$(sed -n 's/.*kafkaVersion = "\(.*\)";/\1/p' "$fname")
scala_version=$(sed -n 's/.*scalaVersion = "\(.*\)";/\1/p' "$fname")
echoerr "Current: kafkaVersion=$current_kafka_version scalaVersion=$scala_version"

# Build a regex that matches e.g. "4.1.0", "4.1.1", but not "4.1.0-rc1".
series_re="^$(echo "$series" | sed 's/\./\\./g')\\.[0-9]+$"

# Fetch tags from the Apache Kafka GitHub repo.
# Tags are plain semver (no "v" prefix); filter out release candidates.
latest_version=$(
  { for page in 1 2 3; do
      curl -fsSL ${GITHUB_TOKEN:+-u ":${GITHUB_TOKEN}"} \
        "https://api.github.com/repos/apache/kafka/tags?per_page=100&page=$page"
    done; } \
  | jq -r '.[].name' \
  | grep -E "$series_re" \
  | sort -V \
  | tail -1
)

if [[ -z "$latest_version" ]]; then
  echoerr "Error: no tags found for series $series"
  exit 1
fi

echoerr "Latest version for series $series: $latest_version"

if [[ "$latest_version" == "$current_kafka_version" ]]; then
  echoerr "Already at latest version $latest_version, nothing to do"
  exit 0
fi

# Update kafkaVersion in the nix file.
sed -i -E "s|(kafkaVersion = \").*(\";)|\1$latest_version\2|" "$fname"
grep -q "kafkaVersion = \"$latest_version\"" "$fname"

# Compute new SRI hash for the Apache mirror tarball.
tarball_url="https://archive.apache.org/dist/kafka/${latest_version}/kafka_${scala_version}-${latest_version}.tgz"
echoerr "Fetching hash for: $tarball_url"

new_hash=$(nix-prefetch-url --type sha256 "$tarball_url" 2>/dev/null)
if [[ -z "$new_hash" ]]; then
  echoerr "Error: failed to fetch hash for $tarball_url"
  exit 1
fi
new_hash=$(nix hash convert --hash-algo sha256 --to sri "$new_hash")

echoerr "New hash: $new_hash"
sed -i -E "s|(hash = \").*(\";)|\1$new_hash\2|" "$fname"
grep -q "$new_hash" "$fname"

echoerr "Done. Updated $fname from $current_kafka_version to $latest_version"
