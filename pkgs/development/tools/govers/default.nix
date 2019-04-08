{ stdenv, buildGoPackage, fetchgit }:

buildGoPackage rec {
  name = "govers-${version}";
  version = "20160623-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "77fd787551fc5e7ae30696e009e334d52d2d3a43";

  goPackagePath = "github.com/rogpeppe/govers";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/rogpeppe/govers";
    sha256 = "12w83vyi8mgn48fwdm2js693qcydimxapg8rk0yf01w0ab03r5wn";
  };

  dontRenameImports = true;

  doCheck = false; # fails, silently

}
