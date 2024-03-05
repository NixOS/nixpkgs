{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation rec {
  pname = "fairymax";
  version = "4.8";

  src = fetchurl {
    url = "http://home.hccnet.nl/h.g.muller/fmax4_8w.c";
    hash = "sha256-ikn+CA5lxtDYSDT+Nsv1tfORhKW6/vlmHcGAT9SFfQc=";
  };

  ini = fetchurl {
    url = "http://home.hccnet.nl/h.g.muller/fmax.ini";
    hash = "sha256-lh2ivXx4jNdWn3pT1WKKNEvkVQ31JfdDx+vqNx44nf8=";
  };

  unpackPhase = ''
    cp ${src} fairymax.c
    cp ${ini} fmax.ini
  '';

  buildPhase = ''
    cc *.c -Wno-return-type \
      -o fairymax \
      -DINI_FILE='"'"$out/share/fairymax/fmax.ini"'"'
  '';

  installPhase = ''
    mkdir -p "$out"/{bin,share/fairymax}
    cp fairymax "$out/bin"
    cp fmax.ini "$out/share/fairymax"
  '';

  meta = with lib; {
    homepage = "http://home.hccnet.nl/h.g.muller/dwnldpage.html";
    description = "A small chess engine supporting fairy pieces";
    longDescription = ''
       A version of micro-Max that reads the piece description from a file
       fmax.ini, so that arbitrary fairy pieces can be implemented. This version
       (4.8J) supports up to 15 piece types, and board sizes up to 12x8.
    '';
    license = licenses.free;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.all;
  };
}
