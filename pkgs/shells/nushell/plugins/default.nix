{ lib, newScope, IOKit, CoreFoundation }:

lib.makeScope newScope (self: with self; {
  gstat = callPackage ./gstat.nix { };
  query = callPackage ./query.nix { inherit IOKit CoreFoundation; };
})
