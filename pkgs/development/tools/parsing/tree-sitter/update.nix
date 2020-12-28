{ writeShellScript, nix-prefetch-git, formats, lib
, curl, jq, xe
, src }:

let
  # Grammars we want to fetch from the tree-sitter github orga
  knownTreeSitterOrgGrammarRepos = [
    "tree-sitter-javascript"
    "tree-sitter-c"
    "tree-sitter-swift"
    "tree-sitter-json"
    "tree-sitter-cpp"
    "tree-sitter-ruby"
    "tree-sitter-razor"
    "tree-sitter-go"
    "tree-sitter-c-sharp"
    "tree-sitter-python"
    "tree-sitter-typescript"
    "tree-sitter-rust"
    "tree-sitter-bash"
    "tree-sitter-php"
    "tree-sitter-java"
    "tree-sitter-scala"
    "tree-sitter-ocaml"
    "tree-sitter-julia"
    "tree-sitter-agda"
    "tree-sitter-fluent"
    "tree-sitter-html"
    "tree-sitter-haskell"
    "tree-sitter-regex"
    "tree-sitter-css"
    "tree-sitter-verilog"
    "tree-sitter-jsdoc"
    "tree-sitter-ql"
    "tree-sitter-embedded-template"
  ];
  knownTreeSitterOrgGrammarReposJson = jsonFile "known-tree-sitter-org-grammar-repos" knownTreeSitterOrgGrammarRepos;

  # repos of the tree-sitter github orga we want to ignore (not grammars)
  ignoredTreeSitterOrgRepos = [
    "tree-sitter"
    "tree-sitter-cli"
    # this is the haskell language bindings, tree-sitter-haskell is the grammar
    "haskell-tree-sitter"
    # this is the ruby language bindings, tree-sitter-ruby is the grammar
    "ruby-tree-sitter"
    # this is the (unmaintained) rust language bindings, tree-sitter-rust is the grammar
    "rust-tree-sitter"
    # this is the nodejs language bindings, tree-sitter-javascript is the grammar
    "node-tree-sitter"
    # this is the python language bindings, tree-sitter-python is the grammar
    "py-tree-sitter"
    # afl fuzzing for tree sitter
    "afl-tree-sitter"
    # archived
    "highlight-schema"
    # website
    "tree-sitter.github.io"
  ];
  ignoredTreeSitterOrgReposJson = jsonFile "ignored-tree-sitter-org-repos" ignoredTreeSitterOrgRepos;

  jsonFile = name: val: (formats.json {}).generate name val;

  # check the tree-sitter orga repos
  checkTreeSitterRepos = writeShellScript "get-grammars.sh" ''
    set -euo pipefail
    res=$(${jq}/bin/jq \
      --slurpfile known "${knownTreeSitterOrgGrammarReposJson}" \
      --slurpfile ignore "${ignoredTreeSitterOrgReposJson}" \
      '. - ($known[0] + $ignore[0])' \
      )
    if [ ! "$res" == "[]" ]; then
      echo "These repositories are neither known nor ignored:" 1>&2
      echo "$res" 1>&2
      exit 1
    fi
  '';

  # TODO
  urlEscape = x: x;

  # generic bash script to find the latest github release for a repo
  latestGithubRelease = { owner, repo }: writeShellScript "latest-github-release" ''
    set -euo pipefail
    res=$(${curl}/bin/curl \
      --silent \
      "https://api.github.com/repos/${urlEscape owner}/${urlEscape repo}/releases/latest")
    if [[ "$(printf "%s" "$res" | ${jq}/bin/jq '.message?')" =~ "rate limit" ]]; then
      echo "rate limited" >&2
    fi
    release=$(printf "%s" "$res" | ${jq}/bin/jq '.tag_name')
    # github sometimes returns an empty list even tough there are releases
    if [ "$release" = "null" ]; then
      echo "uh-oh, latest for ${owner + "/" + repo} is not there, using HEAD" >&2
      release="HEAD"
    fi
    echo "$release"
  '';

  # find the latest repos of a github organization
  latestGithubRepos = { orga }: writeShellScript "latest-github-repos" ''
    set -euo pipefail
    res=$(${curl}/bin/curl \
      --silent \
      'https://api.github.com/orgs/${urlEscape orga}/repos?per_page=100')

    if [[ "$(printf "%s" "$res" | ${jq}/bin/jq '.message?')" =~ "rate limit" ]]; then
      echo "rate limited" >&2   #
    fi

    printf "%s" "$res" | ${jq}/bin/jq 'map(.name)' \
      || echo "failed $res"
  '';

  # update one tree-sitter grammar repo and print their nix-prefetch-git output
  updateGrammar = { owner, repo }: writeShellScript "update-grammar.sh" ''
    set -euo pipefail
    latest="$(${latestGithubRelease { inherit owner repo; }})"
    echo "Fetching latest release ($latest) of ${repo} …" >&2
    ${nix-prefetch-git}/bin/nix-prefetch-git \
      --quiet \
      --no-deepClone \
      --url "https://github.com/${urlEscape owner}/${urlEscape repo}" \
      --rev "$latest"
    '';

  foreachSh = list: f: lib.concatMapStringsSep "\n" f list;

  update-all-grammars = writeShellScript "update-all-grammars.sh" ''
    set -euo pipefail
    echo "fetching list of grammars" 1>&2
    treeSitterRepos=$(${latestGithubRepos { orga = "tree-sitter"; }})
    echo "checking the tree-sitter repo list against the grammars we know" 1>&2
    printf '%s' "$treeSitterRepos" | ${checkTreeSitterRepos}
    outputDir="${toString ./.}/grammars"
    echo "writing files to $outputDir" 1>&2
    mkdir -p "$outputDir"
    ${foreachSh knownTreeSitterOrgGrammarRepos
      (repo: ''${updateGrammar { owner = "tree-sitter"; inherit repo; }} > $outputDir/${repo}.json'')}
    ( echo "{"
      ${foreachSh knownTreeSitterOrgGrammarRepos
        (repo: ''
           # indentation hack
             printf "  %s = (builtins.fromJSON (builtins.readFile ./%s.json));\n" "${repo}" "${repo}"'')}
      echo "}" ) \
      > "$outputDir/default.nix"
  '';

in update-all-grammars
