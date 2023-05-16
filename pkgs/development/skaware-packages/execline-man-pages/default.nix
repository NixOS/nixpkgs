{ lib, buildManPages }:

buildManPages {
  pname = "execline-man-pages";
<<<<<<< HEAD
  version = "2.9.3.0.5";
  sha256 = "0fcjrj4xp7y7n1c55k45rxr5m7zpv6cbhrkxlxymd4j603i9jh6d";
=======
  version = "2.9.0.0.1";
  sha256 = "sha256-hT0YsuYJ3XSMYwtlwDR8PGlD8ng8XPky93rCprruHu8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  description = "Port of the documentation for the execline suite to mdoc";
  maintainers = [ lib.maintainers.sternenseemann ];
}
