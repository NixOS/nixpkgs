#! /usr/bin/env nix-shell
#! nix-shell -i bash -p coreutils jq "callPackage ./nix-prefetch-openvsx { }" "callPackage ./nix-prefetch-vscode-mktplc { }"
set -eu -o pipefail

# Helper to just fail with a message and non-zero exit code.
function fail() {
    echo "$1" >&2
    exit 1
}

function get_vsixpkg() {
    PUBLISHER=$1
    NAME=$2
    N="$PUBLISHER-$NAME"

    USE_MS_MKTPLC="false";
    local FETCHED_JSON_STRING="";
    if [[ "$#" -ge 3 ]] && [[ -n "$3" ]] && [[ "$3" = "true" ]]; then
        USE_MS_MKTPLC="true"
        FETCHED_JSON_STRING="$(nix-prefetch-vscode-mktplc "$PUBLISHER" "$NAME")"
    else
        FETCHED_JSON_STRING="$(nix-prefetch-openvsx "$PUBLISHER" "$NAME")"
    fi
    if [[ -z "$FETCHED_JSON_STRING" ]]; then
        return 1
    fi
    VER="$(echo $FETCHED_JSON_STRING | jq -r ".version")"
    SHA="$(echo $FETCHED_JSON_STRING | jq -r ".sha256")"

    cat <<-EOF
  {
    name = "$NAME";
    publisher = "$PUBLISHER";
    version = "$VER";
    useMSMktplc = $USE_MS_MKTPLC;
    sha256 = "$SHA";
  }
EOF
}

CODE=""

PREFER_MS_MKTPLC=false
ONLY_USE_GIVEN=false

while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -h|--help)
            cat <<END_HELP
Usage: update_installed_exts.sh [OPTIONS] CODE="$(comman -v vscode)"

Print a list of mktplcRef of the latest version
of the locally installed vscode extensions
in Nix expressions.

Use 2>/dev/null to supress the error message.

Options:
  -h, --help            Print this help message and exit

  --prefer-openvsx      (Default) First find the extensions on
                        Open VSX Registry and then the official marketplace

  --only-openvsx        Only find the extensions on Open VSX Registry

  --prefer-ms    First find the extensions on the official marketplace
                        and then from Open VSX Registry

  --only-ms      Only find the extensions from the official marketplace
END_HELP
            exit 0
            ;;
        --prefer-openvsx)
            PREFER_MS_MKTPLC=false
            ONLY_USE_GIVEN=false
            shift
            ;;
        --only-openvsx)
            PREFER_MS_MKTPLC=false
            ONLY_USE_GIVEN=true
            shift
            ;;
        --prefer-ms)
            PREFER_MS_MKTPLC=true
            ONLY_USE_GIVEN=false
            shift
            ;;
        --only-ms)
            PREFER_MS_MKTPLC=true
            ONLY_USE_GIVEN=true
            shift
            ;;
        *)
            CODE="$1"
            shift
            ;;
    esac
done

# See if we can find our `code` binary somewhere.
if [[ -z "$CODE" ]]; then
    CODE="$(command -v code)"
fi

if [[ -z "$CODE" ]]; then
    # Not much point continuing.
    fail "VSCode executable not found"
fi

# Begin the printing of the nix expression that will house the list of extensions.
printf '{ extensions = [\n'

# Note that we are only looking to update extensions that are already installed.
for i in $($CODE --list-extensions)
do
    PUBLISHER="$(echo "$i" | sed -r 's/^(.*)\.[^\.]*$/\1/')"
    NAME="$(echo "$i" | sed -r 's/^.*\.([^\.]*)$/\1/')"

    # This is meant to continue even if error occurs,
    # since not all extensions are updatable in this way
    get_vsixpkg "$PUBLISHER" "$NAME" "$PREFER_MS_MKTPLC" || (
        if ! $ONLY_USE_GIVEN; then
            SUPPLEMENT_IS_MS_MKTPLC=true
            if $PREFER_MS_MKTPLC; then
                SUPPLEMENT_IS_MS_MKTPLC=false
            fi
            get_vsixpkg "$PUBLISHER" "$NAME" "$SUPPLEMENT_IS_MS_MKTPLC"
        fi
    ) || true

done
# Close off the nix expression.
printf '];\n}'
