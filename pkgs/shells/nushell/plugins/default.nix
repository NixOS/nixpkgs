<<<<<<< HEAD
{ lib, newScope, IOKit, CoreFoundation, Foundation, Security }:

lib.makeScope newScope (self: with self; {
  gstat = callPackage ./gstat.nix { inherit Security; };
  formats = callPackage ./formats.nix { inherit IOKit Foundation; };
=======
{ lib, newScope, IOKit, CoreFoundation }:

lib.makeScope newScope (self: with self; {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  query = callPackage ./query.nix { inherit IOKit CoreFoundation; };
})
