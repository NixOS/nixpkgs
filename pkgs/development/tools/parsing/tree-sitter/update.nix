{ writeShellScript
, writeText
, writers
, nix-prefetch-git
, formats
, lib
, coreutils
, curl
, xe
}:

# Grammar list:
# https://github.com/tree-sitter/tree-sitter/blob/master/docs/index.md

let
  # Grammars we want to fetch from the tree-sitter github orga
  knownTreeSitterOrgGrammarRepos = [
    "tree-sitter-javascript"
    "tree-sitter-c"
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
    "tree-sitter-html"
    "tree-sitter-haskell"
    "tree-sitter-regex"
    "tree-sitter-css"
    "tree-sitter-verilog"
    "tree-sitter-jsdoc"
    "tree-sitter-ql"
    "tree-sitter-ql-dbscheme"
    "tree-sitter-embedded-template"
    "tree-sitter-tsq"
    "tree-sitter-toml"
  ];
  knownTreeSitterOrgGrammarReposJson = jsonFile "known-tree-sitter-org-grammar-repos" knownTreeSitterOrgGrammarRepos;

  # repos of the tree-sitter github orga we want to ignore (not grammars)
  ignoredTreeSitterOrgRepos = [
    "tree-sitter"
    "tree-sitter-cli"
    # this is the haskell language bindings, tree-sitter-haskell is the grammar
    "haskell-tree-sitter"
    # this is the ruby language bindings, tree-sitter-ruby is the grammar
    "ruby-tree-sitter.old"
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
    # abandoned
    "tree-sitter-swift"
    # abandoned
    "tree-sitter-agda"
    # abandoned
    "tree-sitter-fluent"
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
    "tree-sitter-rego" = {
      orga = "FallenAngel97";
      repo = "tree-sitter-rego";
    };
    "tree-sitter-rst" = {
      orga = "stsewd";
      repo = "tree-sitter-rst";
    };
    "tree-sitter-svelte" = {
      orga = "Himujjal";
      repo = "tree-sitter-svelte";
    };
    "tree-sitter-sql" = {
      orga = "derekstride";
      repo = "tree-sitter-sql";
      branch = "gh-pages";
    };
    "tree-sitter-vim" = {
      orga = "vigoux";
      repo = "tree-sitter-viml";
    };
    "tree-sitter-yaml" = {
      orga = "ikatyang";
      repo = "tree-sitter-yaml";
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
    "tree-sitter-gowork" = {
      orga = "omertuc";
      repo = "tree-sitter-go-work";
    };
    "tree-sitter-graphql" = {
      orga = "bkegley";
      repo = "tree-sitter-graphql";
    };
    "tree-sitter-pgn" = {
      orga = "rolandwalker";
      repo = "tree-sitter-pgn";
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
    "tree-sitter-eex" = {
      orga = "connorlay";
      repo = "tree-sitter-eex";
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
    "tree-sitter-janet-simple" = {
      orga = "sogaiu";
      repo = "tree-sitter-janet-simple";
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
    "tree-sitter-hcl" = {
      orga = "MichaHoffmann";
      repo = "tree-sitter-hcl";
    };
    "tree-sitter-scheme" = {
      orga = "6cdh";
      repo = "tree-sitter-scheme";
    };
    "tree-sitter-tiger" = {
      orga = "ambroisie";
      repo = "tree-sitter-tiger";
    };
    "tree-sitter-nickel" = {
      orga = "nickel-lang";
      repo = "tree-sitter-nickel";
    };
    "tree-sitter-smithy" = {
      orga = "indoorvivants";
      repo = "tree-sitter-smithy";
    };
    "tree-sitter-jsonnet" = {
      orga = "sourcegraph";
      repo = "tree-sitter-jsonnet";
    };
    "tree-sitter-solidity" = {
      orga = "JoranHonig";
      repo = "tree-sitter-solidity";
    };
    "tree-sitter-nu" = {
      orga = "LhKipp";
      repo = "tree-sitter-nu";
    };
    "tree-sitter-cue" = {
      orga = "eonpatapon";
      repo = "tree-sitter-cue";
    };
    "tree-sitter-wing" = {
      orga = "winglang";
      repo = "wing";
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
    lib.attrsets.unionOfDisjoint otherGrammars treeSitterOrgaGrammars;



  jsonFile = name: val: (formats.json { }).generate name val;

  # implementation of the updater
  updateImpl = passArgs "updateImpl-with-args" {
      binaries = {
        curl = "${curl}/bin/curl";
        nix-prefetch-git = "${nix-prefetch-git}/bin/nix-prefetch-git";
        printf = "${coreutils}/bin/printf";
      };
      inherit
        knownTreeSitterOrgGrammarRepos
        ignoredTreeSitterOrgRepos
        ;
    }
    (writers.writePython3 "updateImpl" {
        flakeIgnore = ["E501"];
    } ./update_impl.py);

  # Pass the given arguments to the command, in the ARGS environment variable.
  # The arguments are just a json object that should be available in the script.
  passArgs = name: argAttrs: script: writeShellScript name ''
    env ARGS="$(< ${jsonFile "${name}-args" argAttrs})" \
      ${script} "$@"
  '';

  foreachSh = attrs: f:
    lib.concatMapStringsSep "\n" f
      (lib.mapAttrsToList (k: v: { name = k; } // v) attrs);

  jsonNewlines = lib.concatMapStringsSep "\n" (lib.generators.toJSON {});

  # Run the given script for each of the attr list.
  # The attrs are passed to the script as a json value.
  forEachParallel = name: script: listOfAttrs: writeShellScript "for-each-parallel.sh" ''
    < ${writeText "${name}.json" (jsonNewlines listOfAttrs)} \
      ${xe}/bin/xe -F -j5 ${script} {}
  '';

  # The output directory in the current source tree.
  # This will depend on your local environment, but that is intentional.
  outputDir = "${toString ./.}/grammars";

  update-all-grammars = writeShellScript "update-all-grammars.sh" ''
    set -euo pipefail
   ${updateImpl} fetch-and-check-tree-sitter-repos '{}'
    echo "writing files to ${outputDir}" 1>&2
    mkdir -p "${outputDir}"
    ${forEachParallel
        "repos-to-fetch"
        (writeShellScript "fetch-repo" ''
            ${updateImpl} fetch-repo "$1"
        '')
        (lib.mapAttrsToList
          (nixRepoAttrName: attrs: attrs // {
            inherit
              nixRepoAttrName
              outputDir;
          })
          allGrammars)
    }
    ${updateImpl} print-all-grammars-nix-file "$(< ${
        jsonFile "all-grammars.json" {
          allGrammars =
            (lib.mapAttrsToList
              (nixRepoAttrName: attrs: attrs // {
                inherit nixRepoAttrName;
              })
              allGrammars);
          inherit outputDir;
        }
    })"
  '';


in
update-all-grammars
