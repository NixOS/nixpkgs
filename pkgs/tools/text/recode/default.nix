# XXX: this may need -liconv on non-glibc systems.. 

{ stdenv, fetchgit, python, perl, autoconf, automake, libtool, intltool, flex }:

stdenv.mkDerivation rec {
  name = "recode-3.7-pff85fdbd";

  src = fetchgit {
    url = https://github.com/pinard/Recode.git;
    rev = "2fd8385658e5a08700e3b916053f6680ff85fdbd";
    sha256 = "1xhlfmqld6af16l444jli9crj9brym2jihg1n6lkxh2gar68f5l7";
  };

  buildInputs = [ python perl autoconf automake libtool intltool flex ];

  preConfigure = ''
    # fix build with new automake, https://bugs.gentoo.org/show_bug.cgi?id=419455
    #rm acinclude.m4
    substituteInPlace Makefile.am --replace "ACLOCAL = ./aclocal.sh @ACLOCAL@" ""
    sed -i '/^AM_C_PROTOTYPES/d' configure.ac
    substituteInPlace src/Makefile.am --replace "ansi2knr" ""

    autoreconf -fi
  '';

  #doCheck = true; # doesn't work yet

  preCheck = ''
    checkFlagsArray=(CPPFLAGS="-I../lib" LDFLAGS="-L../src/.libs -Wl,-rpath=../src/.libs")
  '';

  meta = {
    homepage = "http://www.gnu.org/software/recode/";
    description = "Converts files between various character sets and usages";
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ jcumming ];
  };
}
