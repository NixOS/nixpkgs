{
  lib,
  writeScript,
}:

{
  finalAttrs ? { },
  name ? finalAttrs.pname,
  owner ? finalAttrs.src.owner,
  repo ? finalAttrs.src.repo,
  page ? "releases?per_page=10",
  # Newest major this set accepts; a newer major goes into a new rocmPackages_X.
  maxMajor ? 10,
  # input: array of [ { tag_name: "therock-10.1", }, { tag_name: "rocm-7.2.4" }, ... ]. some entries
  # may have bad names like rocm-test-date we want to skip
  # output: the highest proper version with major <= maxMajor, if any. Releases are not
  # ordered by version (a rocm-7.2.x maintenance release can follow therock-10.1).
  filter ? lib.concatStringsSep " | " [
    "map(.tag_name // .name)"
    "map(select(test(\"^(rocm|therock)-[0-9]+\\\\.[0-9]+(\\\\.[0-9]+)?$\")) | sub(\"^(rocm|therock)-\"; \"\"))"
    "map(select((split(\".\")[0] | tonumber) <= ${toString maxMajor}))"
    "sort_by(split(\".\") | map(tonumber)) | last // empty"
  ],
}:

let
  pname =
    if lib.hasPrefix "rocm-llvm-" name then "llvm.${lib.removePrefix "rocm-llvm-" name}" else name;

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
      # Wrap in array if not already an array to make handling specific release or tags page the same
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

    if (( ''${version_arr[0]} > ${toString maxMajor} )); then
      echo "'rocmPackages.${pname}' is already at its maximum allowed version.''\nAny further upgrades should go into 'rocmPackages_X.${pname}'." >&2
      exit 1
    fi

    update-source-version rocmPackages.${pname} "$version" --ignore-same-hash
  '';
in
[ updateScript ]
