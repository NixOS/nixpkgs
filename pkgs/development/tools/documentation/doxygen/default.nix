{ lib
, stdenv
, cmake
, fetchFromGitHub
, fetchpatch
, python3
, flex
, bison
, qt5
, CoreServices
, libiconv
, spdlog
, sqlite
}:

stdenv.mkDerivation rec {
  pname = "doxygen";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "doxygen";
    repo = "doxygen";
    rev = "Release_${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-4zSaM49TjOaZvrUChM4dNJLondCsQPSArOXZnTHS4yI=";
  };

  patches = [
    # fix clang-19 build. can drop on next update
    # https://github.com/doxygen/doxygen/pull/11064
    (fetchpatch {
      name = "fix-clang-19-build.patch";
      url = "https://github.com/doxygen/doxygen/commit/cff64a87dea7596fd506a85521d4df4616dc845f.patch";
      hash = "sha256-TtkVfV9Ep8/+VGbTjP4NOP8K3p1+A78M+voAIQ+lzOk=";
    })
  ];

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

  buildInputs = [ libiconv spdlog sqlite ]
    ++ lib.optionals (qt5 != null) (with qt5; [ qtbase wrapQtAppsHook ])
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ CoreServices ];

  cmakeFlags = [
    "-DICONV_INCLUDE_DIR=${libiconv}/include"
    "-Duse_sys_spdlog=ON"
    "-Duse_sys_sqlite3=ON"
  ] ++ lib.optional (qt5 != null) "-Dbuild_wizard=YES";

  # put examples in an output so people/tools can test against them
  outputs = [ "out" "examples" ];
  postInstall = ''
    cp -r ../examples $examples
  '';

  meta = {
    license = lib.licenses.gpl2Plus;
    homepage = "https://www.doxygen.nl/";
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
}
