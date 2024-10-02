{ lib
, stdenv
, fetchzip
, zlib
}:

stdenv.mkDerivation rec {
  pname = "offzip";
  version = "0.4.1";

  src = fetchzip {
    url = "https://web.archive.org/web/20230419080810/https://aluigi.altervista.org/mytoolz/offzip.zip";
    hash = "sha256-dmYeSdtNvx6FBuyCdiu+q1ExEfgN8fDO8coyJmFrjKY=";
    stripRoot = false;
  };

  buildInputs = [
    zlib
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "Tool to unpack the zip data contained in any type of file";
    homepage = "https://aluigi.altervista.org/mytoolz.htm#offzip";
    license = lib.licenses.gpl2Plus;
    maintainers = with maintainers; [ r-burns ];
    platforms = platforms.unix;
    mainProgram = "offzip";
  };
}
