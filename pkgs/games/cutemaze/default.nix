{ lib
, stdenv
, fetchurl
, cmake
, qttools
, wrapQtAppsHook
, qtbase
, qtwayland
, qtsvg
}:

stdenv.mkDerivation rec {
  pname = "cutemaze";
  version = "1.3.2";

  src = fetchurl {
    url = "https://gottcode.org/cutemaze/${pname}-${version}.tar.bz2";
    hash = "sha256-hjDlY18O+VDJR68vwrIZwsQAa40xU+V3bCAA4GFHJEQ=";
  };

  nativeBuildInputs = [
    cmake
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtwayland
    qtsvg
  ];

  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    mv CuteMaze.app $out/Applications
  '';

  meta = with lib; {
    changelog = "https://github.com/gottcode/cutemaze/blob/v${version}/ChangeLog";
    description = "Simple, top-down game in which mazes are randomly generated";
    homepage = "https://gottcode.org/cutemaze/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
    platforms = platforms.unix;
  };
}
