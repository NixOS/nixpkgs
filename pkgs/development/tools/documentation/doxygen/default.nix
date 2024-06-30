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
, withSqlite ? true, sqlite
}:

stdenv.mkDerivation rec {
  pname = "doxygen";
  version = "1.9.7";

  src = fetchFromGitHub {
    owner = "doxygen";
    repo = "doxygen";
    rev = "Release_${lib.replaceStrings [ "." ] [ "_" ] version}";
    sha256 = "sha256-ezeMQk+Vyi9qNsYwbaRRruaIYGY8stFf71W7GonXqco=";
  };

  patches = [
    (fetchpatch {
      name = "drop-usage-bad-actor-polyfill.io.patch";
      url = "https://github.com/doxygen/doxygen/commit/41e3eeed6d7c34d14f072cbfea5fe418fc65a760.patch";
      hash = "sha256-vtuVO6v2Hccm2W+Ilv3a2kmBMrRyYLCYVWLyZKx0s7s=";
    })
  ];

  nativeBuildInputs = [
    cmake
    python3
    flex
    bison
  ];

  buildInputs = [ libiconv ]
    ++ lib.optionals withSqlite [ sqlite ]
    ++ lib.optionals (qt5 != null) (with qt5; [ qtbase wrapQtAppsHook ])
    ++ lib.optionals stdenv.isDarwin [ CoreServices ];

  cmakeFlags = [ "-DICONV_INCLUDE_DIR=${libiconv}/include" ]
    ++ lib.optional withSqlite "-Duse_sqlite3=ON"
    ++ lib.optional (qt5 != null) "-Dbuild_wizard=YES";

  env.NIX_CFLAGS_COMPILE =
    lib.optionalString stdenv.isDarwin "-mmacosx-version-min=10.9";

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
