{ stdenv, lib, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "confd-${version}";
  version = "0.9.0";
  rev = "v${version}";

  goPackagePath = "github.com/kelseyhightower/confd";
  subPackages = [ "./" ];

  src = fetchgit {
    inherit rev;
    url = "https://github.com/kelseyhightower/confd";
    sha256 = "0rz533575hdcln8ciqaz79wbnga3czj243g7fz8869db6sa7jwlr";
  };

  goDeps = ./deps.json;
}
