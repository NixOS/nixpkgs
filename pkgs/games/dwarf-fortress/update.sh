#!/usr/bin/env nix-shell
#! nix-shell -i bash -p jq nix coreutils curl

# systems to generate hashes for
systems='linux osx'

if [ $# -eq 0 ]; then
    versions="$(curl http://www.bay12games.com/dwarves/ \
           | grep 'DWARF FORTRESS CLASSIC ' \
           | sed 's/.*DWARF FORTRESS CLASSIC \([0-9.]*\) .*/\1/')"
else
    versions="$@"
fi

tmp1="$(mktemp)"
tmp2="$(mktemp)"
for version in $versions; do
    for system in $systems; do
    echo -n $version,$system,
    ver=$(echo $version | sed -e s,^0\.,, | tr . _)
    if [[ "$system" = *win* ]] || [[ "$system" = *legacy* ]]; then
        ext=zip
    else
        ext=tar.bz2
    fi
    nix-prefetch-url \
        http://www.bay12games.com/dwarves/df_${ver}_${system}.${ext}
    done
done | jq --slurp --raw-input \
      'split("\n")  | .[:-1] | map(split(",")) |
           map({ "version": .[0], "platform": .[1], "sha256": .[2] }) |
       group_by(.version) |
       map(map({"version": .version, (.platform): .sha256}) | add |
           {(.version): .} | map_values(del(.version))) | add' \
      > "$tmp1"

# Append $tmp1 to game.json. There should be a better way to handle
# this but all other attempts failed for me.
jq -M --slurpfile a "$tmp1" '. + $a[]' < "$(dirname "$0")/game.json" > "$tmp2"
cat "$tmp2" > "$(dirname "$0")/game.json"
