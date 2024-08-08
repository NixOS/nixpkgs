{ lib
, pkgs
, callPackage
}:

let
  src = pkgs.fetchFromGitHub {
    owner = "Openmesh-Network";
    repo = "xnode-personaliser";
    rev = "e2b09aeea33f4b32d1ed109c0ea1d71667e92305";
    sha256 = "sha256-JrPgnhGlKT16BBqrhcHszNtXGahf/hHkd9eGTavQsC8=";
  };
in
import src
