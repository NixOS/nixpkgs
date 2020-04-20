{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "hyx-0.1.5";

  src = fetchurl {
    url = "https://yx7.cc/code/hyx/${name}.tar.xz";
    sha256 = "0gd8fbdyw12jwffa5dgcql4ry22xbdhqdds1qwzk1rkcrkgnc1mg";
  };

  patches = [ ./no-wall-by-default.patch ];

  installPhase = ''
    install -vD hyx $out/bin/hyx
  '';

  meta = with lib; {
    description = "minimalistic but powerful Linux console hex editor";
    homepage = "https://yx7.cc/code/";
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.linux;
  };
}
