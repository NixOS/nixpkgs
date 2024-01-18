#!/usr/bin/env nix-shell
#!nix-shell -i nu -p nushell common-updater-scripts prefetch-npm-deps

def main [] {
  let tags = list-git-tags --url=https://github.com/advplyr/audiobookshelf | lines | sort --natural | str replace v ''

  let latest_tag = $tags | last
  let current_version = open ./pkgs/servers/audiobookshelf/source.json | get version

  if $latest_tag != $current_version {
    let source = nix-prefetch-github advplyr audiobookshelf --rev $"v($latest_tag)" | from json | merge { version: $latest_tag, depsHash: "", clientDepsHash: ""}
    $source | save --force $"(pwd)/pkgs/servers/audiobookshelf/source.json"

    let srcPath = nix-build $env.PWD -A audiobookshelf.src | complete | get stdout | lines | first

    print $srcPath
    ls $srcPath

    $source | merge {
      depsHash: (prefetch-npm-deps $"($srcPath)/package-lock.json"),
      clientDepsHash: (prefetch-npm-deps $"($srcPath)/client/package-lock.json")
    } | save --force $"(pwd)/pkgs/servers/audiobookshelf/source.json"

    # appease the editorconfig CI check
    echo "\n" | save --append $"(pwd)/pkgs/servers/audiobookshelf/source.json"
  }

  {before: $current_version, after: $latest_tag}
}
