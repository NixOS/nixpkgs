{ stdenv, lib, fetchFromSourcehut, pkg-config, openssl, mime-types, scdoc }:

stdenv.mkDerivation rec {
  pname = "gmnisrv";
  version = "unstable-2021-05-16";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "gmnisrv";
    rev = "b9a92193e96bbe621ebc8430d8308d45a5b86cef";
    sha256 = "sha256-eMKsoq3Y+eS20nxI7EoDLbdwdoB6shbGt6p8wS+uoPc=";
  };

  MIMEDB = "${mime-types}/etc/mime.types";
  nativeBuildInputs = [ pkg-config scdoc ];
  buildInputs = [ openssl mime-types ];

  meta = with lib; {
    description = "A simple Gemini protocol server";
    homepage = "https://git.sr.ht/~sircmpwn/gmnisrv";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ bsima jb55 ];
    platforms = platforms.linux;
  };
}
