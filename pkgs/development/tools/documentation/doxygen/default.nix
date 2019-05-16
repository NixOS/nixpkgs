{ stdenv, cmake, fetchurl, perl, python, flex, bison, qt4, CoreServices, libiconv }:

stdenv.mkDerivation rec {

  name = "doxygen-1.8.15";

  src = fetchurl {
    urls = [
      "mirror://sourceforge/doxygen/${name}.src.tar.gz" # faster, with https, etc.
      "http://doxygen.nl/files/${name}.src.tar.gz"
    ];
    sha256 = "bd9c0ec462b6a9b5b41ede97bede5458e0d7bb40d4cfa27f6f622eb33c59245d";
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
  doCheck = false; # fails

  meta = {
    license = stdenv.lib.licenses.gpl2Plus;
    homepage = http://doxygen.nl/;
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
