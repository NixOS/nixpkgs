{stdenv, fetchurl, autoconf, automake, libtool, gettext, perl}:

let
  asIfPatch = ./recode-3.6-as-if.patch;

  gettextPatch = ./recode-3.6-gettextfix.diff;

  debianPatch = fetchurl {
    url = "http://ftp.de.debian.org/debian/pool/main/r/recode/recode_3.6-15.diff.gz";
    sha256 = "114qxm29wk95w5760bswgd46d5p00g5kbfai5wchjvcbi722p5qf";
  };
in
stdenv.mkDerivation {
  name = "recode-3.6";

  src = fetchurl {
    url = "ftp://ftp.halifax.rwth-aachen.de/gnu/recode/recode-3.6.tar.gz";
    sha256 = "1krgjqfhsxcls4qvxhagc45sm1sd0w69jm81nwm0bip5z3rs9rp3";
  };

  buildInputs = [ autoconf automake libtool gettext perl ];

  patchPhase = ''
    patch -Np1 -i ${asIfPatch}
    patch -Np1 -i ${gettextPatch}
    gunzip <${debianPatch} | patch -Np1 -i -
    sed -i '1i#include <stdlib.h>' src/argmatch.c
    rm -f acinclude.m4
    autoreconf -fi
    libtoolize
  '';

  configureFlags = "--without-included-gettext";

  doCheck = true;

  meta = {
    homepage = "http://www.gnu.org/software/recode/";
    description = "Converts files between various character sets and usages";

    license = "GPLv2+";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [];
  };
}
