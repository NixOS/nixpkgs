{ mkDerivation, lib, fetchFromGitHub, cmake, antlr
, qtbase, qttools, sqlite }:

mkDerivation rec {
  pname = "sqlitebrowser";
  version = "3.12.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "1arv4rzl8s1vjjqzz35l2b1rfzr2b8b23v97fdw1kdxpwvs63l99";
  };

  # We should be using qscintilla from nixpkgs instead of the vendored version,
  # but qscintilla is currently in a bit of a mess as some consumers expect a
  # -qt4 or -qt5 prefix while others do not.
  # We *really* should get that cleaned up.
  buildInputs = [ antlr qtbase sqlite ];

  nativeBuildInputs = [ cmake qttools ];

  meta = with lib; {
    description = "DB Browser for SQLite";
    homepage = "https://sqlitebrowser.org/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.unix;
  };
}
