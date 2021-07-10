#! /usr/bin/env nix-shell
#! nix-shell -i bash -p curl jq unzip
set -eu -o pipefail

# This script reads Visual Studio Code extension (VSC) names from STDIN and prints
# Nix syntax with the correct and updated versions and shas.
#
# Examples:
#
# $ echo 'ms-toolsai.jupyter' | ./update_exts.sh
#   {
#     name = "jupyter";
#     publisher = "ms-toolsai";
#     version = "2020.12.414227025";
#     sha256 = "1zv5p37qsmp2ycdaizb987b3jw45604vakasrggqk36wkhb4bn1v";
#   }
#
# $ code-insiders --list-extensions | ./update_exts.sh
# ...lots of output as shown above

# Helper to just fail with a message and non-zero exit code.
function fail() {
    echo "$1" >&2
    exit 1
}

# Helper to clean up after ourselves if we're killed by SIGINT.
function clean_up() {
    TDIR="${TMPDIR:-/tmp}"
    echo "Script killed, cleaning up tmpdirs: $TDIR/vscode_exts_*" >&2
    rm -Rf "$TDIR/vscode_exts_*"
}

while IFS=$'\n' read -r line; do
  OWNER=$(echo "$line" | cut -d. -f1)
  EXT=$(echo "$line" | cut -d. -f2)

  # Create a tempdir for the extension download.
  EXTTMP=$(mktemp -d -t vscode_exts_XXXXXXXX)

  URL="https://$OWNER.gallery.vsassets.io/_apis/public/gallery/publisher/$OWNER/extension/$EXT/latest/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"

  # Quietly but delicately curl down the file, blowing up at the first sign of trouble.
  curl --silent --show-error --fail -X GET -o "$EXTTMP/$line.zip" "$URL"
  # Unpack the file we need to stdout then pull out the version
  VER=$(jq -r '.version' <(unzip -qc "$EXTTMP/$line.zip" "extension/package.json"))
  # Calculate the SHA
  SHA=$(nix-hash --flat --base32 --type sha256 "$EXTTMP/$line.zip")

  # Clean up.
  rm -Rf "$EXTTMP"
  # I don't like 'rm -Rf' lurking in my scripts but this seems appropriate.

  cat <<-EOF
{
  name = "$EXT";
  publisher = "$OWNER";
  version = "$VER";
  sha256 = "$SHA";
}
EOF
done
