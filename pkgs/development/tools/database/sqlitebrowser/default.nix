{ mkDerivation, lib, fetchFromGitHub, cmake, antlr
, qtbase, qttools, sqlite }:

mkDerivation rec {
  version = "3.11.2";
  pname = "sqlitebrowser";

  src = fetchFromGitHub {
    repo   = pname;
    owner  = pname;
    rev    = "v${version}";
    sha256 = "0ydd5fg76d5d23byac1f7f8mzx3brmd0cnnkd58qpmlzi7p9hcvx";
  };

  buildInputs = [ qtbase sqlite ];

  nativeBuildInputs = [ cmake antlr qttools ];

  # Use internal `qscintilla` rather than our package to fix the build
  # (https://github.com/sqlitebrowser/sqlitebrowser/issues/1348#issuecomment-374170936).
  # This can probably be removed when https://github.com/NixOS/nixpkgs/pull/56034 is merged.
  cmakeFlags = [ "-DFORCE_INTERNAL_QSCINTILLA=ON" ];

  NIX_LDFLAGS = [
    "-lQt5PrintSupport"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "DB Browser for SQLite";
    homepage = http://sqlitebrowser.org/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ ma27 ];
    platforms = platforms.linux; # can only test on linux
  };
}
