{ stdenv, cmake, fetchurl, python3, flex, bison, qt4, CoreServices, libiconv }:

stdenv.mkDerivation rec {

  name = "doxygen-1.8.18";

  src = fetchurl {
    urls = [
      "mirror://sourceforge/doxygen/${name}.src.tar.gz" # faster, with https, etc.
      "http://doxygen.nl/files/${name}.src.tar.gz"
    ];
    sha256 = "0mh6s1ri1fs5yb27m0avnjsbcxpchgb9aaprq4bd3lj6vjg3s5qq";
  };

  nativeBuildInputs = [
    cmake
    python3
    flex
    bison
  ];

  buildInputs =
       stdenv.lib.optional (qt4 != null) qt4
    ++ stdenv.lib.optional stdenv.isSunOS libiconv
    ++ stdenv.lib.optionals stdenv.isDarwin [ CoreServices libiconv ];

  cmakeFlags =
    [ "-DICONV_INCLUDE_DIR=${libiconv}/include" ] ++
    stdenv.lib.optional (qt4 != null) "-Dbuild_wizard=YES";

  NIX_CFLAGS_COMPILE =
    stdenv.lib.optionalString stdenv.isDarwin "-mmacosx-version-min=10.9";

  enableParallelBuilding = true;
  doCheck = false; # fails

  meta = {
    license = stdenv.lib.licenses.gpl2Plus;
    homepage = "http://doxygen.nl/";
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
