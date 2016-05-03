{ stdenv, fetchurl, getopt, lua, boost, pkgconfig }:

stdenv.mkDerivation rec {
  name = "highlight-${version}";
  version = "3.28";

  src = fetchurl {
    url = "http://www.andre-simon.de/zip/${name}.tar.bz2";
    sha256 = "1kg73isgz3czb1k6ccajqzifahr3zs9ci8168k0dlj31j1nlndin";
  };

  buildInputs = [ getopt lua boost pkgconfig ];

  preConfigure = ''makeFlags="PREFIX=$out conf_dir=$out/etc/highlight/"'';

  meta = {
    description = "Source code highlighting tool";
  };
}
