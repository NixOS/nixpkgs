{ lib, stdenv, fetchurl, SDL2, SDL2_image, libGLU, libGL, cmake, physfs, boost, zip, zlib, unzip, pkg-config }:

stdenv.mkDerivation rec {
  pname = "blobby-volley";
  version = "1.0";

  src = fetchurl {
    url = "mirror://sourceforge/blobby/Blobby%20Volley%202%20%28Linux%29/1.0/blobby2-linux-1.0.tar.gz";
    sha256 = "1qpmbdlyhfbrdsq4vkb6cb3b8mh27fpizb71q4a21ala56g08yms";
  };

  nativeBuildInputs = [ cmake pkg-config zip ];
  buildInputs = [ SDL2 SDL2_image libGLU libGL physfs boost zlib ];

  preConfigure=''
    sed -e '1i#include <iostream>' -i src/NetworkMessage.cpp
  '';

  inherit unzip;

  postInstall = ''
    cp ../data/Icon.bmp "$out/share/blobby/"
    mv "$out/bin"/blobby{,.bin}
    substituteAll "${./blobby.sh}" "$out/bin/blobby"
    chmod a+x "$out/bin/blobby"
  '';

  meta = with lib; {
    description = "A blobby volleyball game";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ raskin ];
    homepage = "https://blobbyvolley.de/";
    downloadPage = "https://sourceforge.net/projects/blobby/files/Blobby%20Volley%202%20%28Linux%29/";
    mainProgram = "blobby";
  };
}
