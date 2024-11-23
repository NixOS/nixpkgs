{ callPackage, fetchFromGitHub }:

callPackage ./generic.nix {
  pname = "sm64ex";
  version = "0-unstable-2024-07-04";

  src = fetchFromGitHub {
    owner = "sm64pc";
    repo = "sm64ex";
    rev = "20bb444562aa1dba79cf6adcb5da632ba580eec3";
    sha256 = "sha256-nw+F0upTetLqib5r5QxmcOauSJccpTydV3soXz9CHLQ=";
  };

  extraMeta = {
    homepage = "https://github.com/sm64pc/sm64ex";
    description = "Super Mario 64 port based off of decompilation";
  };
}
