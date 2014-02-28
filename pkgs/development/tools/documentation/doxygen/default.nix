{ stdenv, fetchurl, perl, python, flex, bison, qt4 }:

let
  name = "doxygen-1.8.6";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "ftp://ftp.stack.nl/pub/users/dimitri/${name}.src.tar.gz";
    sha256 = "0pskjlkbj76m9ka7zi66yj8ffjcv821izv3qxqyyphf0y0jqcwba";
  };

  patches = [ ./tmake.patch ];

  buildInputs =
    [ perl python flex bison ]
    ++ stdenv.lib.optional (qt4 != null) qt4;

  prefixKey = "--prefix ";

  configureFlags =
    [ "--dot dot" ]
    ++ stdenv.lib.optional (qt4 != null) "--with-doxywizard";

  preConfigure =
    ''
      patchShebangs .
    '' + stdenv.lib.optionalString (qt4 != null)
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
