{ stdenv, fetchurl, libelf }:

let
  version = "20130503";
in
stdenv.mkDerivation rec {
  name = "prelink-${version}";

  buildInputs = [
    libelf stdenv.cc.libc (stdenv.lib.getOutput "static" stdenv.cc.libc)
  ];

  src = fetchurl {
    url = "https://people.redhat.com/jakub/prelink/prelink-${version}.tar.bz2";
    sha256 = "1w20f6ilqrz8ca51qhrn1n13h7q1r34k09g33d6l2vwvbrhcffb3";
  };

  meta = {
    homepage = https://people.redhat.com/jakub/prelink/;
    license = "GPL";
    description = "ELF prelinking utility to speed up dynamic linking";
    platforms = stdenv.lib.platforms.linux;
  };
}
