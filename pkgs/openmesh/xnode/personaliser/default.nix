{ lib
, pkgs
, callPackage
}:

let
  src = pkgs.fetchFromGitHub {
    owner = "Openmesh-Network";
    repo = "xnode-personaliser";
    rev = "cbdaf4fe15f6a0efbe19fb41782f11798de4b66a";
    sha256 = lib.fakeHash;
  };
in
import src
