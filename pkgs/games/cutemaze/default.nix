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
  version = "1.3.1";

  src = fetchurl {
    url = "https://gottcode.org/cutemaze/${pname}-${version}-src.tar.bz2";
    sha256 = "6944931cd39e9ef202c11483b7b2b7409a068c52fa5fd4419ff938b1158c72ab";
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
    homepage = "https://gottcode.org/cutemaze/";
    description = "Simple, top-down game in which mazes are randomly generated";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
    platforms = platforms.unix;
  };
}
