{ stdenv, lib, fetchFromSourcehut, pkg-config, openssl, mime-types, scdoc }:

stdenv.mkDerivation rec {
  pname = "gmnisrv";
  version = "1.0";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "gmnisrv";
    rev = version;
    sha256 = "sha256-V9HXXYQIo3zeqZjJEn+dhemNg6AU+ee3FRmBmXgLuYQ=";
  };

  postPatch = ''
    substituteInPlace config.sh \
      --replace "pkg-config" "${stdenv.cc.targetPrefix}pkg-config"
  '';

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
