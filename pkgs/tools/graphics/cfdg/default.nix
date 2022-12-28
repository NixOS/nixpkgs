{ lib, stdenv, fetchFromGitHub, libpng, bison, flex, ffmpeg, icu }:

stdenv.mkDerivation rec {
  pname = "cfdg";
  version = "3.3";
  src = fetchFromGitHub {
    owner = "MtnViewJohn";
    repo = "context-free";
    rev = "Version${version}";
    sha256 = "13m8npccacmgxbs4il45zw53dskjh53ngv2nxahwqw8shjrws4mh";
  };

  nativeBuildInputs = [ bison flex ];
  buildInputs = [ libpng ffmpeg icu ];

  postPatch = ''
    sed -e "/YY_NO_UNISTD/a#include <stdio.h>" -i src-common/cfdg.l
    sed -e '1i#include <algorithm>' -i src-common/{cfdg,builder,ast}.cpp
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp cfdg $out/bin/

    mkdir -p $out/share/doc/${pname}-${version}
    cp *.txt $out/share/doc/${pname}-${version}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Context-free design grammar - a tool for graphics generation";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    homepage = "https://contextfreeart.org/";
    license = licenses.gpl2Only;
  };
}
