{ lib, newScope, IOKit, CoreFoundation }:

lib.makeScope newScope (self: with self; {
  query = callPackage ./query.nix { inherit IOKit CoreFoundation; };
})
