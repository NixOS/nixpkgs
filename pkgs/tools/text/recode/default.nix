{ stdenv, fetchurl, autoconf, automake, libtool, gettext, perl, flex }:

let
  asIfPatch = ./recode-3.6-as-if.patch;

  gettextPatch = ./recode-3.6-gettextfix.diff;

  debianPatch = fetchurl {
    url = "http://ftp.de.debian.org/debian/pool/main/r/recode/recode_3.6-17.diff.gz";
    sha256 = "1iwrggw64faf6lghgm9nzh64vh8m8jd79h6pxqgrmfmplzrzpzjp";
  };
in
stdenv.mkDerivation {
  name = "recode-3.6";

  src = fetchurl {
    url = "ftp://ftp.halifax.rwth-aachen.de/gnu/recode/recode-3.6.tar.gz";
    sha256 = "1krgjqfhsxcls4qvxhagc45sm1sd0w69jm81nwm0bip5z3rs9rp3";
  };

  buildInputs = [ autoconf automake libtool gettext perl flex ];

  patchPhase = ''
    patch -Np1 -i ${gettextPatch}
    patch -Np1 -i ${asIfPatch}
    gunzip <${debianPatch} | patch -Np1 -i -
    sed -i '1i#include <stdlib.h>' src/argmatch.c

    # fix build with new automake, https://bugs.gentoo.org/show_bug.cgi?id=419455
    rm acinclude.m4
    substituteInPlace Makefile.am --replace "ACLOCAL = ./aclocal.sh @ACLOCAL@" ""
    sed -i '/^AM_C_PROTOTYPES/d' configure.in
    substituteInPlace src/Makefile.am --replace "ansi2knr" ""

    autoreconf -i
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
