#
# This derivation verifies that calculating the list of outpaths
# using the old slow ofborg outpaths.nix script produces exactly the
# same results as calculating them the new fast parallel way with
# the pkgs/top-level/release-outpaths-parallel.nix script.
#
# This check needs access to the shared/cached store on the CT
# runner, so it can't be executed via the migration mechanism.  It
# has to wait for OfBorg to merge and deploy this PR:
#
#  https://github.com/NixOS/ofborg/pull/660
#

{ lib ? import ../../../lib
, pkgs ? import ../../.. { }
}:
let

  nixpkgs-source = lib.cleanSource ../../..;

  attrpaths-calculated-the-ofborg-way-drv =
    pkgs.runCommand "attrpaths-calculated-the-ofborg-way.txt" {} ''
      cp -r ${nixpkgs-source} nixpkgs
      mkdir fake-store
      ${pkgs.nix}/bin/nix-env --store ./fake-store \
        -qaP \
        --no-name \
        --arg checkMeta false \
        --argstr path $(pwd)/nixpkgs \
        -f nixpkgs/pkgs/top-level/release-outpaths.nix \
      | sed 's/\.[^.]*$//' \
      | sort \
      | uniq \
      > $out
    '';

  # yes, IFD
  attrpaths-calculated-the-ofborg-way =
    lib.splitString "\n"
      (builtins.readFile
        (import attrpaths-calculated-the-ofborg-way-drv)
      );

  attrpaths-calculated-the-fast-way =
    (import ../../../pkgs/top-level/release-attrpaths-superset.nix { })
      .names;

  attrset-with-every-ofborg-way-attr-set-to-true =
    builtins.listToAttrs
      (map (path: lib.nameValuePair path true)
        attrpaths-calculated-the-ofborg-way);

  attrset-with-every-fast-way-attr-set-to-false =
    builtins.listToAttrs
      (map (path: lib.nameValuePair path false)
        attrpaths-calculated-the-fast-way);

  attrset-should-have-no-true-attrvalues =
    attrset-with-every-ofborg-way-attr-set-to-true
    // attrset-with-every-fast-way-attr-set-to-false;

  failures =
    lib.filter
      (v: v != null)
      (lib.mapAttrsToList
        (k: v: if v == true then k else null)
        attrset-should-have-no-true-attrvalues);

in {
  # should be []
  inherit failures;

  pass = assert failures == [];
}
