{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  name = "gzrt-0.8";

  src = fetchurl {
    url = "http://www.urbanophile.com/arenn/coding/gzrt/${name}.tar.gz";
    sha256 = "1vhzazj47xfpbfhzkwalz27cc0n5gazddmj3kynhk0yxv99xrdxh";
  };

  buildInputs = [ zlib ];

  installPhase = ''
    mkdir -p $out/bin
    cp gzrecover $out/bin
  '';

  meta = {
    homepage = http://www.urbanophile.com/arenn/hacking/gzrt/;
    description = "The gzip Recovery Toolkit";
    license = stdenv.lib.licenses.gpl3;
  };
}
