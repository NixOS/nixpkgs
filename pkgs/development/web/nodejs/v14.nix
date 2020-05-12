{ callPackage, openssl, icu66, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    icu = icu66;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "14.2.0";
    sha256 = "1kqnkqkv2chw9s0hazbaba5y1555h526825xqk4rr441wcxcrzcf";
  }
