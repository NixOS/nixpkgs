#! /usr/bin/env nix-shell
#! nix-shell -i bash -p coreutils dotnet-sdk nix jq
# Script to generate the mono-deps.nix file.
set -e

# Check for dotnet2nix.
if ! command -v dotnet2nix &> /dev/null; then
  echo This script requires dotnet2nix
  echo Please install it from https://github.com/baracoder/dotnet2nix
  exit 1
fi

# Create a temporary directory to store sources/intermediate files.
# It will be deleted when the script finishes or if it is interrupted or fails.
TMPDIR=$(mktemp -d)
trap "rm -r $TMPDIR" EXIT

# Use nix-shell to fetch the package source an unpack it in a temporary directory.
nix-shell -E 'with import <nixpkgs>{}; callPackage ./default.nix {}' --run "cd $TMPDIR && unpackPhase"
cd $TMPDIR/source

# Generate a nugets.json file for each solution.
for solution in `find . -name "*.sln" -type f`; do
  dotnet restore --use-lock-file $solution
  dotnet2nix $(dirname $solution)
  mv nugets.json $(basename $solution).nugets.json
done

# Merge nugets.json files.
jq -c '.[]' *.nugets.json | jq -s | jq -M 'unique_by(.sha512)' > nugets.json

# Write packages to mono-deps.nix file.
cat <<EOF > mono-deps.nix
{ fetchurl }:
[
EOF
for package in `jq -r '.[] | @base64' nugets.json`; do
  getval() {
    echo "$package" | base64 --decode | jq -r $1
  }

  name=$(getval '.fileName')
  url=$(getval '.url')
  sha512=$(getval '.sha512')

  cat <<-EOF >> mono-deps.nix
    (fetchurl {
      name = "$name";
      url = "$url";
      sha512 = "$sha512";
    })
  EOF
done
echo "]" >> mono-deps.nix

cp mono-deps.nix $OLDPWD/mono-deps.nix
