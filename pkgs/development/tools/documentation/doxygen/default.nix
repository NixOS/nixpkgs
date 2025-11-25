{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  python3,
  flex,
  bison,
  qt6,
  libiconv,
  spdlog,
  fmt,
  sqlite,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "doxygen";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "doxygen";
    repo = "doxygen";
    tag = "Release_${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-HbUAIfkfP0Tvb2NLSerTSL8A+8Ox2thgGL2/zGLkZdc=";
  };

  # https://github.com/doxygen/doxygen/issues/10928#issuecomment-2179320509
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'JAVACC_CHAR_TYPE=\"unsigned char\"' \
                     'JAVACC_CHAR_TYPE=\"char8_t\"' \
      --replace-fail "CMAKE_CXX_STANDARD 17" "CMAKE_CXX_STANDARD 20"
  ''
  # otherwise getting linker errors for deps
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)' \
                     'set(CMAKE_INTERPROCEDURAL_OPTIMIZATION FALSE)'
  '';

  nativeBuildInputs = [
    cmake
    python3
    flex
    bison
  ];

  buildInputs = [
    libiconv
    spdlog
    fmt
    sqlite
  ]
  ++ lib.optionals (qt6 != null) [
    qt6.qtbase
    qt6.wrapQtAppsHook
    qt6.qtsvg
  ];

  cmakeFlags = [
    "-Duse_sys_spdlog=ON"
    "-Duse_sys_fmt=ON"
    "-Duse_sys_sqlite3=ON"
  ]
  ++ lib.optional (qt6 != null) "-Dbuild_wizard=YES";

  # put examples in an output so people/tools can test against them
  outputs = [
    "out"
    "examples"
  ];

  postInstall = ''
    cp -r ../examples $examples
  '';

  meta = {
    license = lib.licenses.gpl2Plus;
    homepage = "https://www.doxygen.nl";
    changelog = "https://www.doxygen.nl/manual/changelog.html";
    description = "Source code documentation generator tool";
    mainProgram = "doxygen";
    longDescription = ''
      Doxygen is the de facto standard tool for generating documentation from
      annotated C++ sources, but it also supports other popular programming
      languages such as C, Objective-C, C#, PHP, Java, Python, IDL (Corba,
      Microsoft, and UNO/OpenOffice flavors), Fortran, VHDL and to some extent
      D. It can generate an on-line documentation browser (in HTML) and/or an
      off-line reference manual (in LaTeX) from a set of documented source
      files.
    '';
    platforms = if qt6 != null then lib.platforms.linux else lib.platforms.unix;
  };
})
