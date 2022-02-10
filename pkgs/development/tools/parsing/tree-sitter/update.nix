{ writeShellScript
, nix-prefetch-git
, formats
, lib
, curl
, jq
, xe
, src
}:

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
      orga = "MunifTanjim";
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
      orga = "MDeiml";
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
    "tree-sitter-commonlisp" = {
      orga = "thehamsta";
      repo = "tree-sitter-commonlisp";
    };
    "tree-sitter-cuda" = {
      orga = "thehamsta";
      repo = "tree-sitter-cuda";
    };
    "tree-sitter-glsl" = {
      orga = "thehamsta";
      repo = "tree-sitter-glsl";
    };
    "tree-sitter-dockerfile" = {
      orga = "camdencheek";
      repo = "tree-sitter-dockerfile";
    };
    "tree-sitter-ledger" = {
      orga = "cbarrete";
      repo = "tree-sitter-ledger";
    };
    "tree-sitter-gomod" = {
      orga = "camdencheek";
      repo = "tree-sitter-go-mod";
    };
    "tree-sitter-graphql" = {
      orga = "bkegley";
      repo = "tree-sitter-graphql";
    };
    "tree-sitter-perl" = {
      orga = "ganezdragon";
      repo = "tree-sitter-perl";
    };
    "tree-sitter-kotlin" = {
      orga = "fwcd";
      repo = "tree-sitter-kotlin";
    };
    "tree-sitter-scss" = {
      orga = "serenadeai";
      repo = "tree-sitter-scss";
    };
    "tree-sitter-erlang" = {
      orga = "abstractmachineslab";
      repo = "tree-sitter-erlang";
    };
    "tree-sitter-elixir" = {
      orga = "elixir-lang";
      repo = "tree-sitter-elixir";
    };
    "tree-sitter-surface" = {
      orga = "connorlay";
      repo = "tree-sitter-surface";
    };
    "tree-sitter-heex" = {
      orga = "connorlay";
      repo = "tree-sitter-heex";
    };
    "tree-sitter-supercollider" = {
      orga = "madskjeldgaard";
      repo = "tree-sitter-supercollider";
    };
    "tree-sitter-tlaplus" = {
      orga = "tlaplus-community";
      repo = "tree-sitter-tlaplus";
    };
    "tree-sitter-glimmer" = {
      orga = "alexlafroscia";
      repo = "tree-sitter-glimmer";
    };
    "tree-sitter-pug" = {
      orga = "zealot128";
      repo = "tree-sitter-pug";
    };
    "tree-sitter-vue" = {
      orga = "ikatyang";
      repo = "tree-sitter-vue";
    };
    "tree-sitter-elm" = {
      orga = "elm-tooling";
      repo = "tree-sitter-elm";
    };
    "tree-sitter-yang" = {
      orga = "hubro";
      repo = "tree-sitter-yang";
    };
    "tree-sitter-query" = {
      orga = "nvim-treesitter";
      repo = "tree-sitter-query";
    };
    "tree-sitter-sparql" = {
      orga = "bonabeavis";
      repo = "tree-sitter-sparql";
    };
    "tree-sitter-gdscript" = {
      orga = "prestonknopp";
      repo = "tree-sitter-gdscript";
    };
    "tree-sitter-godot-resource" = {
      orga = "prestonknopp";
      repo = "tree-sitter-godot-resource";
    };
    "tree-sitter-turtle" = {
      orga = "bonabeavis";
      repo = "tree-sitter-turtle";
    };
    "tree-sitter-devicetree" = {
      orga = "joelspadin";
      repo = "tree-sitter-devicetree";
    };
    "tree-sitter-r" = {
      orga = "r-lib";
      repo = "tree-sitter-r";
    };
    "tree-sitter-bibtex" = {
      orga = "latex-lsp";
      repo = "tree-sitter-bibtex";
    };
    "tree-sitter-fortran" = {
      orga = "stadelmanma";
      repo = "tree-sitter-fortran";
    };
    "tree-sitter-cmake" = {
      orga = "uyha";
      repo = "tree-sitter-cmake";
    };
    "tree-sitter-json5" = {
      orga = "joakker";
      repo = "tree-sitter-json5";
    };
    "tree-sitter-pioasm" = {
      orga = "leo60228";
      repo = "tree-sitter-pioasm";
    };
    "tree-sitter-hjson" = {
      orga = "winston0410";
      repo = "tree-sitter-hjson";
    };
    "tree-sitter-llvm" = {
      orga = "benwilliamgraham";
      repo = "tree-sitter-llvm";
    };
    "tree-sitter-http" = {
      orga = "ntbbloodbath";
      repo = "tree-sitter-http";
    };
    "tree-sitter-prisma" = {
      orga = "victorhqc";
      repo = "tree-sitter-prisma";
    };
    "tree-sitter-org-nvim" = {
      orga = "milisims";
      repo = "tree-sitter-org";
    };
  };

  allGrammars =
    let
      treeSitterOrgaGrammars =
        lib.listToAttrs (map
          (repo:
            {
              name = repo;
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
    lib.assertMsg (intersect == [ ])
      (lib.concatStringsSep "\n" [
        "mergeAttrsUnique: keys in attrset overlapping:"
        "left: ${lib.generators.toPretty {} (lib.getAttrs intersect left)}"
        "right: ${lib.generators.toPretty {} (lib.getAttrs intersect right)}"
      ]);
    left // right;



  jsonFile = name: val: (formats.json { }).generate name val;

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

    args=( '--silent' )
    if [ -n "''${GITHUB_TOKEN:-}" ]; then
      args+=( "-H" "Authorization: token ''${GITHUB_TOKEN}" )
    fi
    args+=( "https://api.github.com/repos/${urlEscape orga}/${urlEscape repo}/releases/latest" )

    res=$(${curl}/bin/curl "''${args[@]}")

    if [[ "$(printf "%s" "$res" | ${jq}/bin/jq '.message?')" =~ "rate limit" ]]; then
      echo "rate limited" >&2
    fi
    release="$(printf "%s" "$res" | ${jq}/bin/jq -r '.tag_name')"
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

    args=( '--silent' )
    if [ -n "''${GITHUB_TOKEN:-}" ]; then
      args+=( "-H" "Authorization: token ''${GITHUB_TOKEN}" )
    fi
    args+=( 'https://api.github.com/orgs/${urlEscape orga}/repos?per_page=100' )

    res=$(${curl}/bin/curl "''${args[@]}")

    if [[ "$(printf "%s" "$res" | ${jq}/bin/jq '.message?')" =~ "rate limit" ]]; then
      echo "rate limited" >&2
      exit 1
    elif [[ "$(printf "%s" "$res" | ${jq}/bin/jq '.message?')" =~ "Bad credentials" ]]; then
      echo "bad credentials" >&2
      exit 1
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
    ( echo "{ lib }:"
      echo "{"
      ${foreachSh allGrammars
        ({name, ...}: ''
           # indentation hack
             printf "  %s = lib.importJSON ./%s.json;\n" "${name}" "${name}"'')}
      echo "}" ) \
      > "$outputDir/default.nix"
  '';

in
update-all-grammars
