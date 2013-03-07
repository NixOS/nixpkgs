{ stdenv, fetchurl, perl, flex, bison, qt4 }:

let
  name = "doxygen-1.8.1";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "ftp://ftp.stack.nl/pub/users/dimitri/${name}.src.tar.gz";
    sha256 = "0qmprax8d5fwx6sc7x9l06ilh2ffgvm6xs0rh54k3v5q5879r7mg";
  };

  patches = [ ./tmake.patch ];

  buildInputs =
    [ perl flex bison ]
    ++ stdenv.lib.optional (qt4 != null) qt4;

  prefixKey = "--prefix ";

  configureFlags =
    [ "--dot dot" ]
    ++ stdenv.lib.optional (qt4 != null) "--with-doxywizard";

  preConfigure = stdenv.lib.optionalString (qt4 != null)
    ''
      echo "using QTDIR=${qt4}..."
      export QTDIR=${qt4}
    '';

  makeFlags = "MAN1DIR=share/man/man1";

  enableParallelBuilding = true;

  meta = {
    license = "GPLv2+";
    homepage = "http://doxygen.org/";
    description = "Doxygen, a source code documentation generator tool";

    longDescription = ''
      Doxygen is a documentation system for C++, C, Java, Objective-C,
      Python, IDL (CORBA and Microsoft flavors), Fortran, VHDL, PHP,
      C\#, and to some extent D.  It can generate an on-line
      documentation browser (in HTML) and/or an off-line reference
      manual (in LaTeX) from a set of documented source files.
    '';

    maintainers = [stdenv.lib.maintainers.simons];
    platforms = if qt4 != null then stdenv.lib.platforms.linux else stdenv.lib.platforms.unix;
  };
}
