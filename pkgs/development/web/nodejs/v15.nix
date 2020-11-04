{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "15.1.0";
    sha256 = "1fd0ck6nlmp937j00y17q2k9xszzwf4s383p1z4v4qzj0qzxflvk";
  }
