{ lib, stdenv, cmake, fetchFromGitHub, python3, flex, bison, qt5, CoreServices, libiconv }:

stdenv.mkDerivation rec {
  pname = "doxygen";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "doxygen";
    repo = "doxygen";
    rev = "Release_${lib.replaceStrings [ "." ] [ "_" ] version}";
    sha256 = "0z5wj6plax78a3sshsq1rfjfn1fhq8dnnbpvdk3yv92198bg53xi";
  };

  nativeBuildInputs = [
    cmake
    python3
    flex
    bison
  ];

  buildInputs =
       lib.optionals (qt5 != null) (with qt5; [ qtbase wrapQtAppsHook ])
    ++ lib.optional stdenv.isSunOS libiconv
    ++ lib.optionals stdenv.isDarwin [ CoreServices libiconv ];


  # Last verified as of v1.9.1 that this will race on codegen.
  enableParallelBuild = false;

  cmakeFlags =
    [ "-DICONV_INCLUDE_DIR=${libiconv}/include" ] ++
    lib.optional (qt5 != null) "-Dbuild_wizard=YES";

  NIX_CFLAGS_COMPILE =
    lib.optionalString stdenv.isDarwin "-mmacosx-version-min=10.9";

  enableParallelBuilding = false;

  meta = {
    license = lib.licenses.gpl2Plus;
    homepage = "http://doxygen.nl/";
    changelog = "https://www.doxygen.nl/manual/changelog.html";
    description = "Source code documentation generator tool";

    longDescription = ''
      Doxygen is a documentation system for C++, C, Java, Objective-C,
      Python, IDL (CORBA and Microsoft flavors), Fortran, VHDL, PHP,
      C\#, and to some extent D.  It can generate an on-line
      documentation browser (in HTML) and/or an off-line reference
      manual (in LaTeX) from a set of documented source files.
    '';

    platforms = if qt5 != null then lib.platforms.linux else lib.platforms.unix;
  };
}
