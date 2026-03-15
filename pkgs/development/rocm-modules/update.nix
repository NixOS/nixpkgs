{
  lib,
  writeScript,
}:

{
  name ? "",
  owner ? "",
  repo ? "",
  attrPath ? null,
  file ? null,
  page ? "releases",
  versionKey ? null,
  # input: array of [ { tag_name: "rocm-6.x.x", }, ... ]. some entries may have bad names like rocm-test-date we want to skip
  # output: first tag_name/name that's a proper version if any
  filter ? "map(.tag_name // .name) | map(select(test(\"^rocm-[0-9]+\\\\.[0-9]+(\\\\.[0-9]+)?$\"))) | first | ltrimstr(\"rocm-\")",
}:

let
  pname =
    if lib.hasPrefix "rocm-llvm-" name then "llvm.${lib.removePrefix "rocm-llvm-" name}" else name;
  updateAttrPath = if attrPath != null then attrPath else "rocmPackages.${pname}";

  updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts
    set -euo pipefail

    fetch_releases() {
      local api_url="https://api.github.com/repos/${owner}/${repo}/${page}"
      if [ "${page}" = "releases" ]; then
        api_url="$api_url?per_page=4"
      fi
      >&2 echo $api_url
      curl ''${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL "$api_url"
    }

    find_valid_version() {
      local releases="$1"
      >&2 echo "$releases"
      # Wrap in array if not already an array to make handline specific release or tags page the same
      >&2 echo jq -r 'if type == "array" then . else [.] end | ${filter}'
      echo "$releases" | jq -r 'if type == "array" then . else [.] end | ${filter}'
    }

    releases="$(fetch_releases)"
    version="$(find_valid_version "$releases")"

    if [ -z "$version" ]; then
      echo "No valid version found in the fetched release(s)." >&2
      exit 1
    fi

    IFS='.' read -ra version_arr <<< "$version"

    >&2 echo parsed version "$version_arr" from "$version"

    if (( ''${version_arr[0]} > 7 )); then
      echo "'${updateAttrPath}' is already at its maximum allowed version.''\nAny further upgrades should go into 'rocmPackages_X.${pname}'." >&2
      exit 1
    fi

    cmd=(update-source-version ${lib.escapeShellArg updateAttrPath} "$version" --ignore-same-hash)
    ${lib.optionalString (file != null) "cmd+=(${lib.escapeShellArg "--file=${file}"})"}
    ${lib.optionalString (
      versionKey != null
    ) "cmd+=(${lib.escapeShellArg "--version-key=${versionKey}"})"}
    "''${cmd[@]}"
  '';
in
[ updateScript ]
