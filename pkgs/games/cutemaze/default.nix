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
    qtsvg
  ] ++ lib.optionals stdenv.isLinux [
    qtwayland
  ];

  installPhase = if stdenv.isDarwin then ''
    runHook preInstall

    mkdir -p $out/Applications
    mv CuteMaze.app $out/Applications
    makeWrapper $out/Applications/CuteMaze.app/Contents/MacOS/CuteMaze $out/bin/cutemaze

    runHook postInstall
  '' else null;

  meta = with lib; {
    changelog = "https://github.com/gottcode/cutemaze/blob/v${version}/ChangeLog";
    description = "Simple, top-down game in which mazes are randomly generated";
    homepage = "https://gottcode.org/cutemaze/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
    platforms = platforms.unix;
  };
}
