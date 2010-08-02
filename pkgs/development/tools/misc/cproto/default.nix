{ stdenv, fetchurl, flex, bison }:

stdenv.mkDerivation {
  name = "cproto-4.6";

  src = fetchurl {
    url = mirror://sourceforge/cproto/cproto-4.6.tar.gz;
    sha256 = "0ilhkx9iwc5bh65q47mf68p39iyk07d52fv00z431nl6qcb9hp9j";
  };

  buildInputs = [flex bison];

  # patch made by Joe Khoobyar copied from gentoo bugs
  patches = ./cproto_patch;

  meta = { 
    description = "Tool to generate C function prototypes from C source code";
    homepage = http://cproto.sourceforge.net/;
    license = "public domain";
  };
}
