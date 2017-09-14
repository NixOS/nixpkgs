{ stdenv, fetchurl, libpng, bison, flex, ffmpeg }:

stdenv.mkDerivation rec {
  name = "cfdg-${version}";
  version = "3.0.2";
  src = fetchurl {
    sha256 = "1pd1hjippbhad8l4s4lsglykh22i24qfrgmnxrsx71bvcqbr356p";
    url = "http://www.contextfreeart.org/download/ContextFreeSource${version}.tgz";
  };

  buildInputs = [ libpng bison flex ffmpeg ];

  postPatch = ''
    sed -e "/YY_NO_UNISTD/a#include <stdio.h>" -i src-common/cfdg.l
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp cfdg $out/bin/

    mkdir -p $out/share/doc/${name}
    cp *.txt $out/share/doc/${name}
  '';

  meta = with stdenv.lib; {
    description = "Context-free design grammar - a tool for graphics generation";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    homepage = https://contextfreeart.org/;
    downloadPage = "https://contextfreeart.org/mediawiki/index.php/Download_page";
  };
}
