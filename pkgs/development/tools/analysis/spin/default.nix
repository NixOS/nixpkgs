{stdenv, fetchurl, flex, yacc, tk }:

stdenv.mkDerivation {
  name = "spin-5.1.7";

  src = fetchurl {
    url = http://spinroot.com/spin/Src/spin517.tar.gz;
    sha256 = "03c6bmar4z13jx7dddb029f0qnmgl8x4hyfwn3qijjyd4dbliiw6";
  };

  buildInputs = [ flex yacc tk ];

  patchPhase = ''
    cd Src*
    sed -i -e 's/-DNXT/-DNXT -DCPP="\\"gcc -E -x c\\""/' makefile
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp ../Xspin*/xsp* $out/bin/xspin
    sed -i -e '1s@^#!/bin/sh@#!${tk}/bin/wish@' \
      -e '/exec wish/d' $out/bin/xspin
    cp spin $out/bin
  '';

  meta = {
    description = "Formal verification tool for distributed software systems";
    homepage = http://spinroot.com/;
    license = "free";
  };
}
