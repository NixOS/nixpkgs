{ stdenv, lib, fetchFromSourcehut, pkg-config, openssl, mime-types, scdoc }:

stdenv.mkDerivation rec {
  pname = "gmnisrv";
  version = "unstable-2021-03-26";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "gmnisrv";
    rev = "f23ec10a6d66c574bbf718c4b10f2cf91ea8daef";
    sha256 = "1d9rjx0s092yfzjxd2yvzixhqgg883nlnmsysgp21w75n2as354n";
  };

  MIMEDB = "${mime-types}/etc/mime.types";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl mime-types scdoc ];

  meta = with lib; {
    description = "A simple Gemini protocol server";
    homepage = "https://git.sr.ht/~sircmpwn/gmnisrv";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ bsima jb55 ];
    platforms = platforms.all;
  };
}
