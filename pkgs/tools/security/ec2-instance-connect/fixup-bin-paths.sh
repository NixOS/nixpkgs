#!/usr/bin/env bash
set -euo pipefail

script_dir=$1
which=$2
search_path=$3


find_absolute_paths() {
    grep -Ehr --only-matching '(/usr)?/bin/\w+' "$1" | sort | uniq
}

resolve_path() {
    local search_path=$1
    local bin=$2
    local base resolved
    base=$(basename "$bin")
    # Use explicit which tool here to force shell builtins to be
    # resolved via the search path. This matches upstream behaviour.
    resolved=$(PATH="$search_path" $which "$base" 2>/dev/null || true)
    if [ "$resolved" ]; then
        echo "Resolved $base -> $resolved" >&2
        echo "$resolved"
    else
        echo "Unable to find $base" >&2
        exit 1
    fi
}

mapfile -t replacements < <(
    find_absolute_paths "$script_dir" | while read -r from; do
        to=$(resolve_path "$search_path" "$from")
        [ -z "$to" ] && exit 1
        printf "%s\n" -e
        echo "s^${from}\b^${to}^g"
    done
)

mapfile -t targets < <(find "$script_dir" -type f)

set -x
sed -i "${replacements[@]}" "${targets[@]}"
