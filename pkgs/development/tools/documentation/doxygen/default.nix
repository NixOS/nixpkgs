{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  python3,
  flex,
  bison,
  qt5,
  libiconv,
  spdlog,
  sqlite,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "doxygen";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "doxygen";
    repo = "doxygen";
    tag = "Release_${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-d90fIP8rDQ30fY1vF3wAPlIa8xrSEOdHTpPjYnduZdI=";
  };

  # https://github.com/doxygen/doxygen/issues/10928#issuecomment-2179320509
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'JAVACC_CHAR_TYPE=\"unsigned char\"' \
                     'JAVACC_CHAR_TYPE=\"char8_t\"' \
      --replace-fail "CMAKE_CXX_STANDARD 17" "CMAKE_CXX_STANDARD 20"
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
    sqlite
  ]
  ++ lib.optionals (qt5 != null) (
    with qt5;
    [
      qtbase
      wrapQtAppsHook
    ]
  );

  cmakeFlags = [
    "-Duse_sys_spdlog=ON"
    "-Duse_sys_sqlite3=ON"
  ]
  ++ lib.optional (qt5 != null) "-Dbuild_wizard=YES";

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
    platforms = if qt5 != null then lib.platforms.linux else lib.platforms.unix;
  };
})
