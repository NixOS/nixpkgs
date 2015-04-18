{ stdenv, fetchurl, getopt, lua, boost, pkgconfig }:

stdenv.mkDerivation rec {
  name = "highlight-3.18";

  src = fetchurl {
    url = "http://www.andre-simon.de/zip/${name}.tar.bz2";
    sha256 = "0jsq78qb75sawwggbpx5pdqxk00wgjr1a0la0w8wihmamsjzgijm";
  };

  buildInputs = [ getopt lua boost pkgconfig ];

  preConfigure = ''makeFlags="PREFIX=$out conf_dir=$out/etc/highlight"'';

  meta = {
    description = "Source code highlighting tool";
  };
}
