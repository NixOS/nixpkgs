{ lib, newScope, IOKit, CoreFoundation, Foundation, Security }:

lib.makeScope newScope (self: with self; {
  gstat = callPackage ./gstat.nix { inherit Security; };
  formats = callPackage ./formats.nix { inherit IOKit Foundation; };
  query = callPackage ./query.nix { inherit IOKit CoreFoundation; };
  regex = callPackage ./regex.nix { inherit IOKit; };
  net = callPackage ./net.nix { inherit IOKit CoreFoundation; };
})
