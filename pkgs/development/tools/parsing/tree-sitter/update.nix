{ writeShellScript, nix-prefetch-git
, curl, jq, xe
, src }:

let
  # check in the list of grammars, whether we know all of them.
  checkKnownGrammars = writeShellScript "get-grammars.sh" ''
    set -euo pipefail
    known='
    [ "tree-sitter-javascript"
    , "tree-sitter-c"
    , "tree-sitter-swift"
    , "tree-sitter-json"
    , "tree-sitter-cpp"
    , "tree-sitter-ruby"
    , "tree-sitter-razor"
    , "tree-sitter-go"
    , "tree-sitter-c-sharp"
    , "tree-sitter-python"
    , "tree-sitter-typescript"
    , "tree-sitter-rust"
    , "tree-sitter-bash"
    , "tree-sitter-php"
    , "tree-sitter-java"
    , "tree-sitter-scala"
    , "tree-sitter-ocaml"
    , "tree-sitter-julia"
    , "tree-sitter-agda"
    , "tree-sitter-fluent"
    , "tree-sitter-html"
    , "tree-sitter-haskell"
    , "tree-sitter-regex"
    , "tree-sitter-css"
    , "tree-sitter-verilog"
    , "tree-sitter-jsdoc"
    , "tree-sitter-ql"
    , "tree-sitter-embedded-template"
    ]'
    ignore='
    [ "tree-sitter"
    , "tree-sitter-cli"
    ${/*this is the haskell language bindings, tree-sitter-haskell is the grammar*/""}
    , "haskell-tree-sitter"
    ${/*this is the ruby language bindings, tree-sitter-ruby is the grammar*/""}
    , "ruby-tree-sitter"
    ${/*this is the (unmaintained) rust language bindings, tree-sitter-rust is the grammar*/""}
    , "rust-tree-sitter"
    ${/*this is the nodejs language bindings, tree-sitter-javascript is the grammar*/""}
    , "node-tree-sitter"
    ${/*this is the python language bindings, tree-sitter-python is the grammar*/""}
    , "py-tree-sitter"
    ${/*afl fuzzing for tree sitter*/""}
    , "afl-tree-sitter"
    ${/*archived*/""}
    , "highlight-schema"
    ${/*website*/""}
    , "tree-sitter.github.io"
    ]'
    res=$(${jq}/bin/jq \
      --argjson known "$known" \
      --argjson ignore "$ignore" \
      '. - ($known + $ignore)' \
      )
    if [ ! "$res" == "[]" ]; then
      echo "These repositories are neither known nor ignored:" 1>&2
      echo "$res" 1>&2
      exit 1
    fi
    printf '%s' "$known"
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
    if [[ "$(printf "%s" "$res" | ${jq}/bin/jq '.message?')" =~ "rate limit" ]]; then
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

  # find the latest repos of a github organization
  latestGithubRepos = { orga }: writeShellScript "latest-github-repos" ''
    set -euo pipefail
    res=$(${curl}/bin/curl \
      --silent \
      'https://api.github.com/orgs/${orga}/repos?per_page=100')

    if [[ "$(printf "%s" "$res" | ${jq}/bin/jq '.message?')" =~ "rate limit" ]]; then
      echo "rate limited" >&2
    fi

    printf "%s" "$res" | ${jq}/bin/jq 'map(.name)' \
      || echo "failed $res"
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
    echo "fetching list of grammars" 1>&2
    grammars=$(${latestGithubRepos { orga = "tree-sitter"; }})
    echo "checking against the list of grammars we know" 1>&2
    knownGrammars=$(printf '%s' "$grammars" | ${checkKnownGrammars})
    # change the json list into a item-per-line bash format
    grammarNames=$(printf '%s' "$knownGrammars" | ${jq}/bin/jq --raw-output '.[]')
    outputDir="${toString ./.}/grammars"
    mkdir -p "$outputDir"
    updateCommand=$(printf \
      '${updateGrammar { owner = "tree-sitter"; }} "$1" > "%s/$1.json"' \
      "$outputDir")
    printf '%s' "$grammarNames" \
      | ${xe}/bin/xe -j2 -s "$updateCommand"
    ( echo "{"
      printf '%s' "$grammarNames" \
        | ${xe}/bin/xe -s 'printf "  %s = (builtins.fromJSON (builtins.readFile ./%s.json));\n" "$1" "$1"'
      echo "}" ) \
      > "$outputDir/default.nix"
  '';

in update-all-grammars
