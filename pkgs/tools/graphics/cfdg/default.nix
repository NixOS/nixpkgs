{ stdenv, fetchFromGitHub, libpng, bison, flex, ffmpeg, icu }:

stdenv.mkDerivation rec {
  pname = "cfdg";
  version = "3.2_2";
  src = fetchFromGitHub {
    owner = "MtnViewJohn";
    repo = "context-free";
    rev = "Version${version}";
    sha256 = "14v1gya7h0p9dj16hw87wpmjfddmkz537w3kjvaribgxxp0gzyz5";
  };

  buildInputs = [ libpng bison flex ffmpeg icu ];

  postPatch = ''
    sed -e "/YY_NO_UNISTD/a#include <stdio.h>" -i src-common/cfdg.l
    sed -e '1i#include <algorithm>' -i src-common/{cfdg,builder,ast}.cpp
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp cfdg $out/bin/

    mkdir -p $out/share/doc/${pname}-${version}
    cp *.txt $out/share/doc/${pname}-${version}
  '';

  meta = with stdenv.lib; {
    description = "Context-free design grammar - a tool for graphics generation";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    homepage = "https://contextfreeart.org/";
    license = licenses.gpl2;
  };
}
