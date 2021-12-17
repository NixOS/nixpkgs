{ writeShellScript, nix-prefetch-git, formats, lib
, curl, jq, xe
, src }:

# Grammar list:
# https://github.com/tree-sitter/tree-sitter/blob/master/docs/index.md

let
  # Grammars we want to fetch from the tree-sitter github orga
  knownTreeSitterOrgGrammarRepos = [
    "tree-sitter-javascript"
    "tree-sitter-c"
    "tree-sitter-swift"
    "tree-sitter-json"
    "tree-sitter-cpp"
    "tree-sitter-ruby"
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
    "tree-sitter-tsq"
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
    # not maintained
    "tree-sitter-razor"
    # rust library for constructing arbitrary graph structures from source code
    "tree-sitter-graph"
  ];
  ignoredTreeSitterOrgReposJson = jsonFile "ignored-tree-sitter-org-repos" ignoredTreeSitterOrgRepos;

  # Additional grammars that are not in the official github orga.
  # If you need a grammar that already exists in the official orga,
  # make sure to give it a different name.
  otherGrammars = {
    "tree-sitter-beancount" = {
      orga = "polarmutex";
      repo = "tree-sitter-beancount";
    };
    "tree-sitter-clojure" = {
      orga = "sogaiu";
      repo = "tree-sitter-clojure";
    };
    "tree-sitter-comment" = {
      orga = "stsewd";
      repo = "tree-sitter-comment";
    };
    "tree-sitter-dart" = {
      orga = "usernobody14";
      repo = "tree-sitter-dart";
    };
    "tree-sitter-elisp" = {
      orga = "wilfred";
      repo = "tree-sitter-elisp";
    };
    "tree-sitter-nix" = {
      orga = "cstrahan";
      repo = "tree-sitter-nix";
    };
    "tree-sitter-latex" = {
      orga = "latex-lsp";
      repo = "tree-sitter-latex";
    };
    "tree-sitter-lua" = {
      orga = "nvim-treesitter";
      repo = "tree-sitter-lua";
    };
    "tree-sitter-fennel" = {
      orga = "travonted";
      repo = "tree-sitter-fennel";
    };
    "tree-sitter-make" = {
      orga = "alemuller";
      repo = "tree-sitter-make";
    };
    "tree-sitter-markdown" = {
      orga = "ikatyang";
      repo = "tree-sitter-markdown";
    };
    "tree-sitter-rst" = {
      orga = "stsewd";
      repo = "tree-sitter-rst";
    };
    "tree-sitter-svelte" = {
      orga = "Himujjal";
      repo = "tree-sitter-svelte";
    };
    "tree-sitter-vim" = {
      orga = "vigoux";
      repo = "tree-sitter-viml";
    };
    "tree-sitter-yaml" = {
      orga = "ikatyang";
      repo = "tree-sitter-yaml";
    };
    "tree-sitter-toml" = {
      orga = "ikatyang";
      repo = "tree-sitter-toml";
    };
    "tree-sitter-zig" = {
      orga = "maxxnino";
      repo = "tree-sitter-zig";
    };
    "tree-sitter-fish" = {
      orga = "ram02z";
      repo = "tree-sitter-fish";
    };
    "tree-sitter-dot" = {
      orga = "rydesun";
      repo = "tree-sitter-dot";
    };
    "tree-sitter-norg" = {
      orga = "nvim-neorg";
      repo = "tree-sitter-norg";
    };
  };

  allGrammars =
    let
      treeSitterOrgaGrammars =
        lib.listToAttrs (map (repo:
          { name = repo;
            value = {
              orga = "tree-sitter";
              inherit repo;
            };
          })
        knownTreeSitterOrgGrammarRepos);

    in
      mergeAttrsUnique otherGrammars treeSitterOrgaGrammars;

  # TODO: move to lib
  mergeAttrsUnique = left: right:
    let intersect = lib.intersectLists (lib.attrNames left) (lib.attrNames right); in
    assert
      lib.assertMsg (intersect == [])
        (lib.concatStringsSep "\n" [
          "mergeAttrsUnique: keys in attrset overlapping:"
          "left: ${lib.generators.toPretty {} (lib.getAttrs intersect left)}"
          "right: ${lib.generators.toPretty {} (lib.getAttrs intersect right)}"
        ]);
    left // right;



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
  latestGithubRelease = { orga, repo }: writeShellScript "latest-github-release" ''
    set -euo pipefail
    res=$(${curl}/bin/curl \
      --silent \
      "https://api.github.com/repos/${urlEscape orga}/${urlEscape repo}/releases/latest")
    if [[ "$(printf "%s" "$res" | ${jq}/bin/jq '.message?')" =~ "rate limit" ]]; then
      echo "rate limited" >&2
    fi
    release=$(printf "%s" "$res" | ${jq}/bin/jq '.tag_name')
    # github sometimes returns an empty list even tough there are releases
    if [ "$release" = "null" ]; then
      echo "uh-oh, latest for ${orga + "/" + repo} is not there, using HEAD" >&2
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
  updateGrammar = { orga, repo }: writeShellScript "update-grammar.sh" ''
    set -euo pipefail
    latest="$(${latestGithubRelease { inherit orga repo; }})"
    echo "Fetching latest release ($latest) of ${repo} …" >&2
    ${nix-prefetch-git}/bin/nix-prefetch-git \
      --quiet \
      --no-deepClone \
      --url "https://github.com/${urlEscape orga}/${urlEscape repo}" \
      --rev "$latest"
    '';

  foreachSh = attrs: f:
    lib.concatMapStringsSep "\n" f
    (lib.mapAttrsToList (k: v: { name = k; } // v) attrs);

  update-all-grammars = writeShellScript "update-all-grammars.sh" ''
    set -euo pipefail
    echo "fetching list of grammars" 1>&2
    treeSitterRepos=$(${latestGithubRepos { orga = "tree-sitter"; }})
    echo "checking the tree-sitter repo list against the grammars we know" 1>&2
    printf '%s' "$treeSitterRepos" | ${checkTreeSitterRepos}
    outputDir="${toString ./.}/grammars"
    echo "writing files to $outputDir" 1>&2
    mkdir -p "$outputDir"
    ${foreachSh allGrammars
      ({name, orga, repo}: ''${updateGrammar { inherit orga repo; }} > $outputDir/${name}.json'')}
    ( echo "{"
      ${foreachSh allGrammars
        ({name, ...}: ''
           # indentation hack
             printf "  %s = lib.importJSON ./%s.json;\n" "${name}" "${name}"'')}
      echo "}" ) \
      > "$outputDir/default.nix"
  '';

in update-all-grammars
