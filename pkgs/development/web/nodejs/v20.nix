<<<<<<< HEAD
{ callPackage, openssl, python3, enableNpm ? true }:
=======
{ callPackage, openssl, fetchpatch, python3, enableNpm ? true }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
<<<<<<< HEAD
in
buildNodejs {
  inherit enableNpm;
  version = "20.6.1";
  sha256 = "sha256-Ouxeco2qOIAMNDsSkiHTSIBkolKaObtUZ7xVviJsais=";
=======

in
buildNodejs {
  inherit enableNpm;
  version = "20.1.0";
  sha256 = "sha256-YA+eEYYJlYFLkSKxrFMY9q1WQnR4Te7ZjYqSBmSUNrU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  patches = [
    ./revert-arm64-pointer-auth.patch
    ./disable-darwin-v8-system-instrumentation-node19.patch
    ./bypass-darwin-xcrun-node16.patch
<<<<<<< HEAD
    ./node-npm-build-npm-package-logic.patch
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];
}
