{ callPackage, openssl, icu67, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    icu = icu67;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "14.7.0";
    sha256 = "0vwf523ahw0145wp17zkaflwm5823v1vz1kkglj25gzjydiiqbya";
  }
