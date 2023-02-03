{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };

in
buildNodejs {
  inherit enableNpm;
  version = "18.14.0";
  sha256 = "sha256-Qu+d0xmT1cjoKwqwlpE1CT5qKW76J7G+mvwErADwJno=";
  patches = [
    ./disable-darwin-v8-system-instrumentation.patch
    ./bypass-darwin-xcrun-node16.patch
  ];
}
