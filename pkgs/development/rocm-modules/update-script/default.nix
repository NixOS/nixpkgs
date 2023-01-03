{ runtimeShell
, writeScript
}:

{ name ? ""
, owner ? ""
, repo ? ""
, page ? "releases?per_page=1"
, filter ? ".[0].tag_name | split(\"-\") | .[1]"
}:

let
  updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts
    version="$(curl ''${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
      -sL "https://api.github.com/repos/${owner}/${repo}/${page}" | jq '${filter}' --raw-output)"

    IFS='.' read -a version_arr <<< "$version"

    if [ "''${#version_arr[*]}" == 2 ]; then
      version="''${version}.0"
    fi

    update-source-version ${name} "$version" --ignore-same-hash
  '';
in [ updateScript ]
