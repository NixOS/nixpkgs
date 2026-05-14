#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused common-updater-scripts jq prefetch-npm-deps
# shellcheck shell=bash
set -euo pipefail

root="$(dirname "$(readlink -f "$0")")"
repo_root="$(git -C "$root" rev-parse --show-toplevel)"
cd "$repo_root"

github_api_curl_args=()
if [ -n "${GITHUB_TOKEN:-}" ]; then
    github_api_curl_args=(-u ":$GITHUB_TOKEN")
fi

playwright_browsers_file="$root/browsers.json"
playwright_driver_file="$root/driver.nix"
playwright_raw_repo_url="https://raw.githubusercontent.com/microsoft/playwright"
playwright_mcp_package_file="$root/../../../by-name/pl/playwright-mcp/package.nix"
browser_names=(chromium chromium-headless-shell firefox webkit ffmpeg)
browser_systems=(x86_64-linux aarch64-linux x86_64-darwin aarch64-darwin)

github_api_get() {
    curl "${github_api_curl_args[@]}" -fsSL "$1"
}

major_minor() {
    echo "${1%.*}"
}

python_version=$(github_api_get https://api.github.com/repos/microsoft/playwright-python/releases/latest | jq -r '.tag_name | sub("^v"; "")')
# Most of the time, this should be the latest stable release of the Node-based
# Playwright version, but upstream occasionally ships additional npm-only patch
# releases. Resolve the latest patch in the same major.minor series.
setup_py_url="https://github.com/microsoft/playwright-python/raw/v${python_version}/setup.py"
python_driver_version=$(curl -fsSL "$setup_py_url" | grep '^driver_version =' | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+')
python_major_minor=$(major_minor "$python_driver_version")
resolve_driver_version_latest_patch() {
    local mm_escaped
    mm_escaped=${python_major_minor//./\\.}
    curl -fsSL "https://registry.npmjs.org/playwright" \
        | jq -r '.versions | keys[]' \
        | grep -E "^${mm_escaped}\.[0-9]+$" \
        | sort -V \
        | tail -n1
}
driver_version="$(resolve_driver_version_latest_patch)"
: "${driver_version:?failed to resolve driver version from npm for python major.minor ${python_major_minor}}"
: "${python_driver_version:?failed to resolve driver_version from ${setup_py_url}}"

# TODO: skip if update-source-version reported the same version
update-source-version playwright-driver "$driver_version"
update-source-version python3Packages.playwright "$python_version"

temp_dir=$(mktemp -d)
trap 'rm -rf "$temp_dir"' EXIT

# Update playwright-mcp package
driver_major_minor=$(major_minor "$driver_version")
resolve_mcp_version() {
    local releases_json
    local tag_name

    releases_json=$(github_api_get "https://api.github.com/repos/microsoft/playwright-mcp/releases?per_page=100")
    while IFS= read -r tag_name; do
        local mcp_version_candidate mcp_npm_url mcp_playwright_dep mcp_major_minor
        mcp_version_candidate=${tag_name#v}
        mcp_npm_url="https://registry.npmjs.org/@playwright/mcp/${mcp_version_candidate}"
        mcp_playwright_dep=$(
            curl -fsSL "$mcp_npm_url" \
                | jq -r '.dependencies.playwright // .dependencies["playwright-core"] // empty'
        ) || continue
        mcp_major_minor=$(echo "$mcp_playwright_dep" | grep -Eo '[0-9]+\.[0-9]+' | head -n1 || true)
        if [ "$mcp_major_minor" = "$driver_major_minor" ]; then
            echo "$mcp_version_candidate"
            return 0
        fi
    done < <(echo "$releases_json" | jq -r '.[].tag_name')
    return 1
}
mcp_version="$(resolve_mcp_version)" || {
    echo "Could not find a playwright-mcp release compatible with Playwright driver ${driver_version}" >&2
    exit 1
}
update-source-version playwright-mcp "$mcp_version"

# Update npmDepsHash for playwright-mcp
mcp_lock_file="${temp_dir}/playwright-mcp-package-lock.json"
curl -fsSL -o "$mcp_lock_file" "https://raw.githubusercontent.com/microsoft/playwright-mcp/v${mcp_version}/package-lock.json"
mcp_npm_hash=$(prefetch-npm-deps "$mcp_lock_file")

sed -E -i 's#\bnpmDepsHash = "[^"]*"#npmDepsHash = "'"$mcp_npm_hash"'"#' "$playwright_mcp_package_file"


# update binaries of browsers, used by playwright.
replace_sha() {
    local target_file="$1"
    local attr_name="$2"
    local new_hash="$3"

    sed -i "s|$attr_name = \".\{44,52\}\"|$attr_name = \"$new_hash\"|" "$target_file"
}

prefetch_browser() {
    local url="$1"
    local strip_root="$2"
    local fake="sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
    local expr
    local out

    # Use real fetchzip via fake-hash trick. nix-prefetch wrapper is broken on
    # macOS (msteen/nix-prefetch#53), so parse the "got:" line from the
    # mismatch error of a fixed-output derivation instead.
    expr="(import \"$repo_root\" {}).fetchzip { url = \"$url\"; stripRoot = $strip_root; hash = \"$fake\"; }"
    if out=$(nix-build --no-out-link -E "$expr" 2>&1); then
        echo "prefetch_browser: unexpected build success for $url" >&2
        return 1
    fi
    echo "$out" | grep -Eo 'got:[[:space:]]+sha256-[A-Za-z0-9+/=]+' | awk '{print $NF}' | head -n1
}

browser_download_info() {
    local name="$1"
    local revision="$2"
    local browser_version="$3"

    nix-instantiate --eval --json --strict "$root/browser-downloads.nix" \
        --argstr name "$name" \
        --argstr revision "$revision" \
        --argstr browserVersion "$browser_version"
}

update_browser() {
    local name="$1"
    local revision
    local browser_version
    local download_info
    local system
    local url
    local strip_root

    revision="$(jq -r ".browsers[\"$name\"].revision" "$playwright_browsers_file")"
    browser_version="$(jq -r ".browsers[\"$name\"].browserVersion // empty" "$playwright_browsers_file")"
    download_info="$(browser_download_info "$name" "$revision" "$browser_version")"

    for system in "${browser_systems[@]}"; do
        url="$(echo "$download_info" | jq -r --arg system "$system" '.[$system].url')"
        strip_root="$(echo "$download_info" | jq -r --arg system "$system" '.[$system].stripRoot')"
        replace_sha "$root/$name.nix" "$system" "$(prefetch_browser "$url" "$strip_root")"
    done
}

curl -fsSL \
    "https://raw.githubusercontent.com/microsoft/playwright/v${driver_version}/packages/playwright-core/browsers.json" \
    | jq '
      .comment = "This file is kept up to date via update.sh"
      | .browsers |= (
        [.[]
          | select(.installByDefault) | del(.installByDefault)]
          | map({(.name): . | del(.name)})
          | add
      )
    ' > "$playwright_browsers_file"

for browser in "${browser_names[@]}"; do
    update_browser "$browser"
done

# Update package-lock.json files for all npm deps that are built in playwright

# Download `package-lock.json` for a given sourceRoot path and update its hash.
update_hash() {
    local source_root_path="$1"
    local download_url
    local lock_file
    local new_hash
    local source_root_pattern

    download_url="${playwright_raw_repo_url}/v${driver_version}${source_root_path}/package-lock.json"
    lock_file="${temp_dir}/$(echo "$source_root_path" | tr '/.' '__').package-lock.json"
    curl -fsSL -o "$lock_file" "$download_url"
    new_hash=$(prefetch-npm-deps "$lock_file")

    source_root_pattern=$(printf '%s\n' "$source_root_path" | sed 's/[][\\/.*^$+?(){}|]/\\&/g')
    sed -E -i "/sourceRoot = \"\\\$\\{src.name\\}${source_root_pattern}\";/,/npmDepsHash = / s#npmDepsHash = \"[^\"]*\";#npmDepsHash = \"${new_hash}\";#" "$playwright_driver_file"
}

while IFS= read -r source_root_path; do
    update_hash "$source_root_path"
done < <(
    # shellcheck disable=SC2016
    sed -n 's#^[[:space:]]*sourceRoot = "${src.name}\(.*\)";.*$#\1#p' "$playwright_driver_file"
)
