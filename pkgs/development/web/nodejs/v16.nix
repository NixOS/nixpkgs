{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "16.12.0";
    sha256 = "1b3bschfa7946jwyqp3nmbdv7ap3rl4p7h50b9bac08981m0lqjz";
    patches = [ ./disable-darwin-v8-system-instrumentation.patch ];
  }
