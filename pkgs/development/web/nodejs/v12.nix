{ callPackage, openssl, icu, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl icu; };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.6.0";
    sha256 = "12ghr9xy857zpfbgk3ck64rg279gbr1figdfk6lpcvn6vfr4n2ly";
  }
