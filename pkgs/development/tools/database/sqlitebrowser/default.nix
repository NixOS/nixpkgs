{
  lib,
  stdenv,
  mkDerivation,
  fetchFromGitHub,
  cmake,
  qtbase,
  qttools,
  sqlcipher,
  wrapGAppsHook3,
  qtmacextras,
}:

mkDerivation rec {
  pname = "sqlitebrowser";
  version = "3.13.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2U0jnL2hmrxynMxEiObl10bKFAFlCrY2hulZ/Ggqimw=";
  };

  # We should be using qscintilla from nixpkgs instead of the vendored version,
  # but qscintilla is currently in a bit of a mess as some consumers expect a
  # -qt4 or -qt5 prefix while others do not.
  # We *really* should get that cleaned up.
  buildInputs = [
    qtbase
    sqlcipher
  ] ++ lib.optionals stdenv.isDarwin [ qtmacextras ];

  nativeBuildInputs = [
    cmake
    qttools
    wrapGAppsHook3
  ];

  cmakeFlags = [
    "-Dsqlcipher=1"
  ];

  meta = with lib; {
    description = "DB Browser for SQLite";
    mainProgram = "sqlitebrowser";
    homepage = "https://sqlitebrowser.org/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.unix;
  };
}
