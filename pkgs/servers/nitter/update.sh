#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix nix-update patchutils
set -euo pipefail

info() {
    if [ -t 2 ]; then
        set -- '\033[32m%s\033[39m\n' "$@"
    else
        set -- '%s\n' "$@"
    fi
    printf "$@" >&2
}

nitter_old_rev=$(nix-instantiate --eval --strict --json -A nitter.src.rev . | jq -r .)
nix-update --version=branch --commit nitter
nitter_new_rev=$(nix-instantiate --eval --strict --json -A nitter.src.rev . | jq -r .)
if [ "$nitter_new_rev" = "$nitter_old_rev" ]; then
    info "nitter is up-to-date."
    exit
fi

if curl -Sfs "https://github.com/zedeus/nitter/compare/$nitter_old_rev...$nitter_new_rev.patch" \
| lsdiff | grep -Fxe 'a/nitter.nimble' -e 'b/nitter.nimble' > /dev/null; then
    info "nitter.nimble changed, some dependencies probably need updating."
fi
