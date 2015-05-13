{ stdenv, goPackages, fetchFromGitHub, pkgconfig, pkgs }:

with goPackages;

buildGoPackage rec {
  rev = "4c6dbafa5ec35b3ffc6a1b1e1fe29c3eba2053ec";
  name = "openssl-10gen-${stdenv.lib.strings.substring 0 7 rev}";
  goPackagePath = "github.com/spacemonkeygo/openssl";
  src = fetchFromGitHub {
    inherit rev;
    owner = "10gen";
    repo = "openssl";
    sha256 = "1033c9vgv9lf8ks0qjy0ylsmx1hizqxa6izalma8vi30np6ka6zn";
  };
  propagatedBuildInputs = [ spacelog pkgconfig pkgs.openssl ];
}
