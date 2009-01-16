{fetchurl, stdenv, flex, bison, db4}:

stdenv.mkDerivation {
  name = "iproute-2.6.22-070710";

  src = fetchurl {
    url = http://developer.osdl.org/dev/iproute2/download/iproute2-2.6.22-070710.tar.gz;
    sha256 = "3c6b48af9e655e4f0a34c7718e288960a1dc84a3ac7eb726e855adb45fbd953a";
  };
 
  unpackPhase = ''
      mkdir tmp; cd tmp
      unpackFile "$src"
  '';

  patchPhase = ''
    for script in $(find . -type f); do sed -e 's@#! /bin/bash@#! /bin/sh@' -i $script;
    done;
    sed -e s@/usr/lib@$out/lib@ -i tc/Makefile
  '';

  makeFlags = " SBINDIR=\\$(out)/sbin CONFDIR=\\$(out)/etc DOCDIR=\\$(out)/doc MANDIR=\\$(out)/man ";

  buildInputs = [bison flex db4];
}
