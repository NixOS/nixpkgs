{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "govers";
  version = "unstable-2016-06-23";

  goPackagePath = "github.com/rogpeppe/govers";

  src = fetchFromGitHub {
    owner = "rogpeppe";
    repo = "govers";
    rev = "77fd787551fc5e7ae30696e009e334d52d2d3a43";
    sha256 = "sha256-lpc8wFKAB+A8mBm9q3qNzTM8ktFS1MYdIvZVFP0eiIs=";
  };

  dontRenameImports = true;

  doCheck = false; # fails, silently

}
