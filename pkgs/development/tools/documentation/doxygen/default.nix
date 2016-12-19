{ stdenv, cmake, fetchurl, perl, python, flex, bison, qt4, CoreServices, libiconv }:

stdenv.mkDerivation rec {

  name = "doxygen-1.8.11";

  src = fetchurl {
    url = "ftp://ftp.stack.nl/pub/users/dimitri/${name}.src.tar.gz";
    sha256 = "0ja02pm3fpfhc5dkry00kq8mn141cqvdqqpmms373ncbwi38pl35";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs =
    [ perl python flex bison ]
    ++ stdenv.lib.optional (qt4 != null) qt4
    ++ stdenv.lib.optional stdenv.isSunOS libiconv
    ++ stdenv.lib.optionals stdenv.isDarwin [ CoreServices libiconv ];

  cmakeFlags =
    [ "-DICONV_INCLUDE_DIR=${libiconv}/include" ] ++
    stdenv.lib.optional (qt4 != null) "-Dbuild_wizard=YES";

  NIX_CFLAGS_COMPILE =
    stdenv.lib.optional stdenv.isDarwin "-mmacosx-version-min=10.9";

  enableParallelBuilding = true;

  meta = {
    license = stdenv.lib.licenses.gpl2Plus;
    homepage = "http://doxygen.org/";
    description = "Source code documentation generator tool";

    longDescription = ''
      Doxygen is a documentation system for C++, C, Java, Objective-C,
      Python, IDL (CORBA and Microsoft flavors), Fortran, VHDL, PHP,
      C\#, and to some extent D.  It can generate an on-line
      documentation browser (in HTML) and/or an off-line reference
      manual (in LaTeX) from a set of documented source files.
    '';

    platforms = if qt4 != null then stdenv.lib.platforms.linux else stdenv.lib.platforms.unix;
  };
}
