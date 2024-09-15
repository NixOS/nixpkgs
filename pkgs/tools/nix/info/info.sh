#!/bin/bash

PATH="@path@:$PATH"
IS_DARWIN="@is_darwin@"

set -eu
set -o pipefail

DEBUG=0
MARKDOWN=0
HOST_OS=0
SANDBOX=0
while true; do
    case "${1:-}" in
        "")
            break
            ;;
        -d | --debug)
            set -x
            DEBUG=1
            shift
            ;;
        -m | --markdown)
            MARKDOWN=1
            HOST_OS=1
            SANDBOX=1
            shift
            ;;
        --host-os)
            HOST_OS=1
            shift
            ;;
        --sandbox)
            SANDBOX=1
            shift
            ;;

        * )
            cat <<EOF
nix-info - get high level info to help with debugging

Options:

 -m, --markdown   formatting for a GitHub issue
                  implies: --host-os, --sandbox

     --sandbox    include sandbox configuration
     --host-os    include host OS details

 -h, --help       show this message
 -d, --debug      debug mode

EOF
            case "${1:-}" in
                -h|--help)
                    exit 0
                    ;;
                *)
                    exit 1
                    ;;
            esac
    esac
done

debuglog() {
    if [ $DEBUG -eq 1 ]; then
        cat >&2
    else
        cat > /dev/null
    fi
}

nixev() {
    nix-instantiate --eval --strict -E "$1"
}

desc_system() {
    nixev 'builtins.currentSystem'
}

desc_host_os() {
    printf "%s" "$(uname -sr)"

    if [ "$IS_DARWIN" = "yes" ]; then
        printf ", macOS %s" "$(sw_vers -productVersion)"
    fi

    if [ -f /etc/os-release ]; then
        (
            # shellcheck disable=SC1091
            . /etc/os-release
            printf ", %s, %s, %s" "${NAME:-$(uname -v)}" "${VERSION:-noversion}" "${BUILD_ID:-nobuild}"
        )
    fi
}

desc_multi_user() {
    if nix-build --no-out-link  @multiusertest@ 2>&1 | debuglog; then
        printf "yes"
    else
        printf "no"
    fi
}

desc_nixpkgs_path() {
    nixev '<nixpkgs>' 2>/dev/null || echo "not found"
}

channel_facts() {
    find /nix/var/nix/profiles/per-user \
         -mindepth 2 \
         -maxdepth 2 \
         -name channels \
         -print0 \
    |\
    while  IFS= read -r -d '' userchannelset; do
        manifest="$userchannelset/manifest.nix"

        if [ -e "$manifest" ]; then
            userchannels=$(nixev \
                           "builtins.concatStringsSep \", \"
                             (map (ch: ch.name)
                               (import \"$manifest\"))")

            fact "channels($(echo "$manifest" | cut -d/ -f7))" \
                 "$userchannels"
        fi
    done
}

desc_sandbox() {
    if nix-build --no-out-link @sandboxtest@ 2>&1 | debuglog; then
        printf "no"
    elif nix-build --no-out-link @relaxedsandboxtest@ 2>&1 | debuglog; then
        printf "relaxed"
    else
        printf "yes"
    fi
}

fact() {
    name="${1:-0}"
    value="${2:-0}"
    last="${3:-1}"
    if [ $MARKDOWN -eq 0 ]; then
        printf "%s: %s" "$name" "$value"
        if [ "$last" -eq 1 ]; then
            printf ", "
        fi
    else
        printf " - %s: \`%s\`\\n" "$name" "$value"
    fi

    if [ "$last" -eq 0 ]; then
        echo ""
    fi
}

last_fact() {
    fact "$1" "$2" 0
}

fact "system" "$(desc_system)"
if [ $HOST_OS -eq 1 ]; then
    fact "host os" "$(desc_host_os)"
fi
fact "multi-user?" "$(desc_multi_user)"
if [ $SANDBOX -eq 1 ]; then
    fact "sandbox" "$(desc_sandbox)"
fi

fact "version" "$(nix-env --version)"
channel_facts
last_fact "nixpkgs" "$(desc_nixpkgs_path)"
