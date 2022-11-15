{ callPackage, openssl, python3, fetchpatch, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "16.18.1";
    sha256 = "sha256-H4BRqI+G9CBk9EFf56mA5ZsKUC7Mje9YP2MDvE1EUjg=";
    patches = [
      ./disable-darwin-v8-system-instrumentation.patch
      ./bypass-darwin-xcrun-node16.patch
    ];
  }
