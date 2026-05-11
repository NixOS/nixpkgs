#!/usr/bin/env nix-shell
#! nix-shell -i bash -p jq nix coreutils curl nix-prefetch-git

curl "https://api.github.com/users/dfgraphics/repos" | jq -r '.[].name | ascii_downcase' | while read repo; do
    version="$(curl "https://api.github.com/repos/DFgraphics/${repo}/releases/latest" | jq -r .tag_name)"
    sha256="$(nix-prefetch-git "https://github.com/DFgraphics/${repo}" "${version}" | jq -r ".sha256")"
    echo "{}" | jq ".name=\"${repo}\" | .version=\"${version}\" | .sha256=\"${sha256}\""
done | jq -s . > themes.json
