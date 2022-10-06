
# Automatically generated with maintainers/scripts/update-minetest-packages.tcl
# DO NOT EDIT

{ lib, buildMinetestPackage, fetchurl }:

let spdx = lib.listToAttrs
  (lib.filter (attr: attr.name != null)
    (lib.mapAttrsToList (n: l: lib.nameValuePair (l.spdxId or null) l)
      lib.licenses));

in {

  # To be populated by first run of maintainers/scripts/update-minetest-packages.tcl

}

