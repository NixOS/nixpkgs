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


let
  grammarsToml = builtins.fromTOML (builtins.readFile ./grammars.toml);


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
          grammarsToml.knownTreeSitterOrgGrammarRepos);

    in
    mergeAttrsUnique grammarsToml.otherGrammars treeSitterOrgaGrammars;

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

  # implementation of the updater
  updateImpl = passArgs "updateImpl-with-args" {
      binaries = {
        curl = "${curl}/bin/curl";
        nix-prefetch-git = "${nix-prefetch-git}/bin/nix-prefetch-git";
        printf = "${coreutils}/bin/printf";
      };
      inherit (grammarsToml)
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
