{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qtbase,
  qttools,
  sqlcipher,
  wrapQtAppsHook,
  qtmacextras,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sqlitebrowser";
  version = "3.13.1";

  src = fetchFromGitHub {
    owner = "sqlitebrowser";
    repo = "sqlitebrowser";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-bpZnO8i8MDgOm0f93pBmpy1sZLJQ9R4o4ZLnGfT0JRg=";
  };

  patches = lib.optional stdenv.hostPlatform.isDarwin ./macos.patch;

  # We should be using qscintilla from nixpkgs instead of the vendored version,
  # but qscintilla is currently in a bit of a mess as some consumers expect a
  # -qt4 or -qt5 prefix while others do not.
  # We *really* should get that cleaned up.
  buildInputs = [
    qtbase
    sqlcipher
  ] ++ lib.optional stdenv.hostPlatform.isDarwin qtmacextras;

  nativeBuildInputs = [
    cmake
    qttools
    wrapQtAppsHook
  ];

  cmakeFlags = [
    "-Dsqlcipher=1"
    (lib.cmakeBool "ENABLE_TESTING" (finalAttrs.doCheck or false))
  ];

  doCheck = true;

  meta = with lib; {
    description = "DB Browser for SQLite";
    mainProgram = "sqlitebrowser";
    homepage = "https://sqlitebrowser.org/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.unix;
  };
})
