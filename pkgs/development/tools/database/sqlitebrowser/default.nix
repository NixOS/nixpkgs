{ mkDerivation, lib, fetchFromGitHub, cmake, antlr
, qtbase, qttools, qscintilla, sqlite }:

mkDerivation rec {
  version = "3.10.1";
  name = "sqlitebrowser-${version}";

  src = fetchFromGitHub {
    repo   = "sqlitebrowser";
    owner  = "sqlitebrowser";
    rev    = "v${version}";
    sha256 = "1brzam8yv6sbdmbqsp7vglhd6wlx49g2ap8llr271zrkld4k3kar";
  };

  buildInputs = [ qtbase qscintilla sqlite ];

  nativeBuildInputs = [ cmake antlr qttools ];

  NIX_LDFLAGS = [
    "-lQt5PrintSupport"
  ];

  enableParallelBuilding = true;

  # We have to patch out Test and PrintSupport to make this work with Qt 5.9
  # It can go when the application supports 5.9
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace Test         "" \
      --replace PrintSupport ""

    substituteInPlace libs/qcustomplot-source/CMakeLists.txt \
      --replace PrintSupport ""
  '';

  meta = with lib; {
    description = "DB Browser for SQLite";
    homepage = http://sqlitebrowser.org/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ ma27 ];
    platforms = platforms.linux; # can only test on linux
  };
}
