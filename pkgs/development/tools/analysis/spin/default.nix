{stdenv, fetchurl, flex, yacc, tk }:

stdenv.mkDerivation {
  name = "spin-5.1.7";

  src = fetchurl {
    url = http://spinroot.com/spin/Src/spin517.tar.gz;
    sha256 = "03c6bmar4z13jx7dddb029f0qnmgl8x4hyfwn3qijjyd4dbliiw6";
  };

  preConfigure = "cd Src*";
  buildInputs = [ flex yacc tk ];

  installPhase = ''
    ensureDir $out/bin
    cp ../Xspin*/xsp* $out/bin/xspin
    sed -i -e '1s@^#!/bin/sh@#!${tk}/bin/wish8.4@' \
      -e '/exec wish/d' $out/bin/xspin
    cp spin $out/bin
  '';

  meta = {
    description = "Formal verification tool for distributed software systems";
    homepage = http://spinroot.com/;
    license = "free";
  };
}
