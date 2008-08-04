{stdenv, fetchurl, perl, autoconf}:

stdenv.mkDerivation {
  name = "automake-1.7.9";
  builder = ./builder.sh;
  setupHook = ./setup-hook.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/automake-1.7.9.tar.bz2;
    md5 = "571fd0b0598eb2a27dcf68adcfddfacb";
  };
  buildInputs = [perl autoconf];

  # Don't fixup "#! /bin/sh" in Libtool, otherwise it will use the
  # "fixed" path in generated files!
  dontPatchShebangs = true;
}
