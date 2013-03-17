{stdenv, fetchurl, automake, autoconf, flex, bison }:

stdenv.mkDerivation {
  name = "cuetools-1.3.1";

  src = fetchurl {
    url = https://github.com/svend/cuetools/archive/cuetools-1.3.1.tar.gz;
    sha256 = "1cap3wl0mlcqrjywpz46003w8jws05rr3r87pzqkz1g89v9459dg";
  };

  preConfigure = "autoreconf -fiv";

  buildInputs = [ automake autoconf flex bison ]; 

  meta = {
    description = "cue and toc file parsers and utilities";
    homepage = https://github.com/svend/cuetools;
  };
}
