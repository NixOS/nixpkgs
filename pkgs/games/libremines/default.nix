{ lib
, stdenv
, fetchFromGitHub
, cmake
, wrapQtAppsHook
, qtmultimedia
, qtwayland
}:

stdenv.mkDerivation rec {
  pname = "libremines";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "Bollos00";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-TQwjEgtqAvKnrpia6VloRgFwtq5TNDmxU+ZWjtEK/n8=";
  };

  nativeBuildInputs = [ cmake wrapQtAppsHook ];

  buildInputs = [
    qtmultimedia
  ] ++ lib.optionals stdenv.isLinux [
    qtwayland
  ];

  cmakeFlags = [ "-DUSE_QT6=TRUE" ];

  meta = with lib; {
    description = "Qt based Minesweeper game";
    mainProgram = "libremines";
    longDescription = ''
      A Free/Libre and Open Source Software Qt based Minesweeper game available for GNU/Linux, FreeBSD and Windows systems.
    '';
    homepage = "https://bollos00.github.io/LibreMines";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.unix;
  };
}
