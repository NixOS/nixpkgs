{ mkDerivation, lib, fetchFromGitHub, cmake
, qtbase, qttools, sqlite, wrapGAppsHook }:

mkDerivation rec {
  pname = "sqlitebrowser";
  version = "3.12.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "0ray6cscx2qil1dfi7hmpijmq3kba49wn430ih1q4fkz9psjvrz1";
  };

  # We should be using qscintilla from nixpkgs instead of the vendored version,
  # but qscintilla is currently in a bit of a mess as some consumers expect a
  # -qt4 or -qt5 prefix while others do not.
  # We *really* should get that cleaned up.
  buildInputs = [ qtbase sqlite ];

  nativeBuildInputs = [ cmake qttools wrapGAppsHook ];

  meta = with lib; {
    description = "DB Browser for SQLite";
    homepage = "https://sqlitebrowser.org/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.unix;
  };
}
