{ stdenv, fetchurl, perl, flex, bison, qt }:

stdenv.mkDerivation rec {
  name = "doxygen-1.7.4";

  src = fetchurl {
    url = "ftp://ftp.stack.nl/pub/users/dimitri/${name}.src.tar.gz";
    sha256 = "0rnzyp5f8c454fdkgpg5hpxwmx642spgxcpw3blbvnyw8129jp44";
  };

  patches = [ ./tmake.patch ];

  buildInputs =
    [ perl flex bison ]
    ++ stdenv.lib.optional (qt != null) qt;

  prefixKey = "--prefix ";
  
  configureFlags =
    [ "--dot dot" ]
    ++ stdenv.lib.optional (qt != null) "--with-doxywizard";

  preConfigure = stdenv.lib.optionalString (qt != null)
    ''
      echo "using QTDIR=${qt}..."
      export QTDIR=${qt}
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
    platforms = stdenv.lib.platforms.unix;
  };
}
