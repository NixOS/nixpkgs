{ stdenv, cmake, fetchFromGitHub, python3, flex, bison, qt5, CoreServices, libiconv }:

stdenv.mkDerivation rec {
  pname = "doxygen";
  version = "1.8.20";

  src = fetchFromGitHub {
    owner = "doxygen";
    repo = "doxygen";
    rev = "Release_${stdenv.lib.replaceStrings [ "." ] [ "_" ] version}";
    sha256 = "17chvi3i80rj4750smpizf562xjzd2xcv5rfyh997pyvc1zbq5rh";
  };

  nativeBuildInputs = [
    cmake
    python3
    flex
    bison
  ];

  buildInputs =
       stdenv.lib.optionals (qt5 != null) (with qt5; [ qtbase wrapQtAppsHook ])
    ++ stdenv.lib.optional stdenv.isSunOS libiconv
    ++ stdenv.lib.optionals stdenv.isDarwin [ CoreServices libiconv ];

  cmakeFlags =
    [ "-DICONV_INCLUDE_DIR=${libiconv}/include" ] ++
    stdenv.lib.optional (qt5 != null) "-Dbuild_wizard=YES";

  NIX_CFLAGS_COMPILE =
    stdenv.lib.optionalString stdenv.isDarwin "-mmacosx-version-min=10.9";

  enableParallelBuilding = false;

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

    platforms = if qt5 != null then stdenv.lib.platforms.linux else stdenv.lib.platforms.unix;
  };
}
