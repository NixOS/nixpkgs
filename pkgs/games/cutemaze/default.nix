{ lib, stdenv, fetchurl, qmake, qttools, qtsvg, mkDerivation }:

mkDerivation rec {
  pname = "cutemaze";
  version = "1.3.0";

  src = fetchurl {
    url = "https://gottcode.org/cutemaze/${pname}-${version}-src.tar.bz2";
    sha256 = "sha256-h7+H2E37ZVSnlPa6ID+lNEvFtU5PfdMSlBjqBumojoU=";
  };

  nativeBuildInputs = [ qmake qttools ];

  buildInputs = [ qtsvg ];

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
