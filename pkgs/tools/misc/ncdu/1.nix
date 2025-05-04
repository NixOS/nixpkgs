{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "ncdu";
  version = "1.22";

  src = fetchurl {
    url = "https://dev.yorhel.nl/download/${pname}-${version}.tar.gz";
    sha256 = "sha256-CtbAltwE1RIFgRBHYMAbj06X1BkdbJ73llT6PGkaF2s=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ ncurses ];

  meta = with lib; {
    description = "Disk usage analyzer with an ncurses interface";
    homepage = "https://dev.yorhel.nl/ncdu";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub ];
    mainProgram = "ncdu";
  };
}
