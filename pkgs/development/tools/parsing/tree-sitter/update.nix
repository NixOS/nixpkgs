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
      # All grammars in the tree sitter orga we know of
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

      merged =
        mergeAttrsUnique
          grammarsToml.otherGrammars
          treeSitterOrgaGrammars;
    in
      # a list of {nixRepoAttrName, orga, repo}
      lib.mapAttrsToList
        (nixRepoAttrName: attrs: attrs // {
          inherit nixRepoAttrName;
        })
        merged;


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

  # a list of nix values as a newline-separated json string,
  # one entry per line
  jsonNewlines = lib.concatMapStringsSep "\n" (lib.generators.toJSON {});
  # a pretty-printed value as json file
  jsonFile = name: val: (formats.json { }).generate name val;

  # Run the given script for each of the attr list.
  # The attrs are passed to the script as a json value.
  forEachParallel = name: script: listOfAttrs: writeShellScript "for-each-parallel.sh" ''
    < ${writeText "${name}.json" (jsonNewlines listOfAttrs)} \
      ${xe}/bin/xe -F -j5 ${script} {}
  '';

  # The output directory in the current source tree.
  # This will depend on your local environment, but that is intentional.
  outputDir = "${toString ./.}/grammars";

  # final script
  update-all-grammars = writeShellScript "update-all-grammars.sh" ''
    set -euo pipefail

    # first make sure we know about all upsteam repos
    ${updateImpl} fetch-and-check-tree-sitter-repos '{}'

    # Then write one json file for each prefetched repo, in parallel
    echo "writing files to ${outputDir}" 1>&2
    mkdir -p "${outputDir}"
    ${forEachParallel
        "repos-to-fetch"
        (writeShellScript "fetch-repo" ''
            ${updateImpl} fetch-repo "$1"
        '')
        (map
          (grammar: grammar // { inherit outputDir; })
          allGrammars)
    }

    # finally, write a default.nix that calls all grammars
    ${updateImpl} print-all-grammars-nix-file "$(< ${
        jsonFile "all-grammars.json" {
          inherit
            allGrammars
            outputDir;
        }
    })"
  '';


in
update-all-grammars
