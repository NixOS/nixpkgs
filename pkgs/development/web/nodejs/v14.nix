{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "14.15.0";
    sha256 = "0fzv05f8rnc0s1a11k0cqfpgv9yawfbdd8qcl8zr25kv5ridhdip";
  }
