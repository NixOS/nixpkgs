{stdenv, fetchurl, perl, autoconf, makeWrapper}:

stdenv.mkDerivation {
  name = "automake-1.7.9";
  
  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://nixos.org/tarballs/automake-1.7.9.tar.bz2;
    md5 = "571fd0b0598eb2a27dcf68adcfddfacb";
  };
  
  buildInputs = [perl autoconf makeWrapper];

  # Don't fixup "#! /bin/sh" in Libtool, otherwise it will use the
  # "fixed" path in generated files!
  dontPatchShebangs = true;
}
