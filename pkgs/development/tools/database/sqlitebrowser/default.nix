{ mkDerivation, lib, fetchFromGitHub, cmake, antlr
, qtbase, qttools, qscintilla, sqlite }:

mkDerivation rec {
  pname = "sqlitebrowser";
  version = "3.11.2";

  src = fetchFromGitHub {
    owner  = pname;
    repo   = pname;
    rev    = "v${version}";
    sha256 = "0ydd5fg76d5d23byac1f7f8mzx3brmd0cnnkd58qpmlzi7p9hcvx";
  };

  buildInputs = [ antlr qtbase qscintilla sqlite ];

  nativeBuildInputs = [ cmake qttools ];

  NIX_LDFLAGS = "-lQt5PrintSupport";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "DB Browser for SQLite";
    homepage = https://sqlitebrowser.org/;
    license = licenses.gpl3;
    maintainers = with maintainers; [  ];
    platforms = platforms.unix;
  };
}
