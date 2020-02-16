{ writeShellScript, nix-prefetch-git
, curl, jq, xe
, src }:

let
  # print all the grammar names mentioned in the fetch-fixtures script
  getGrammarNames = writeShellScript "get-grammars.sh" ''
    set -euo pipefail
    sed -ne 's/^fetch_grammar \(\S*\).*$/\1/p' \
      ${src}/script/fetch-fixtures
  '';

  # TODO
  urlEscape = x: x;
  # TODO
  urlEscapeSh = writeShellScript "escape-url" ''printf '%s' "$1"'';

  # generic bash script to find the latest github release for a repo
  latestGithubRelease = { owner }: writeShellScript "latest-github-release" ''
    set -euo pipefail
    repo="$1"
    res=$(${curl}/bin/curl \
      --silent \
      "https://api.github.com/repos/${urlEscape owner}/$(${urlEscapeSh} "$repo")/releases/latest")
    if [[ "$(printf "%s" "$res" | ${jq}/bin/jq '.message')" =~ "rate limit" ]]; then
      echo "rate limited" >&2
    fi
    release=$(printf "%s" "$res" | ${jq}/bin/jq '.tag_name')
    # github sometimes returns an empty list even tough there are releases
    if [ "$release" = "null" ]; then
      echo "uh-oh, latest for $repo is not there, using HEAD" >&2
      release="HEAD"
    fi
    echo "$release"
  '';

  # update one tree-sitter grammar repo and print their nix-prefetch-git output
  updateGrammar = { owner }: writeShellScript "update-grammar.sh" ''
    set -euo pipefail
    repo="$1"
    latest="$(${latestGithubRelease { inherit owner; }} "$repo")"
    echo "Fetching latest release ($latest) of $repo …" >&2
    ${nix-prefetch-git}/bin/nix-prefetch-git \
      --quiet \
      --no-deepClone \
      --url "https://github.com/${urlEscape owner}/$(${urlEscapeSh} "$repo")" \
      --rev "$latest"
    '';

  update-all-grammars = writeShellScript "update-all-grammars.sh" ''
    set -euo pipefail
    grammarNames=$(${getGrammarNames})
    outputDir="${toString ./.}/grammars"
    mkdir -p "$outputDir"
    updateCommand=$(printf \
      '${updateGrammar { owner = "tree-sitter"; }} "$1" > "%s/$1.json"' \
      "$outputDir")
    printf '%s' "$grammarNames" \
      | ${xe}/bin/xe printf "tree-sitter-%s\n" {} \
      | ${xe}/bin/xe -j2 -s "$updateCommand"
    ( echo "{"
      printf '%s' "$grammarNames" \
        | ${xe}/bin/xe -s 'printf "  %s = (builtins.fromJSON (builtins.readFile ./tree-sitter-%s.json));\n" "$1" "$1"'
      echo "}" ) \
      > "$outputDir/default.nix"
  '';

in update-all-grammars
