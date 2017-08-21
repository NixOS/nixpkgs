{stdenv, fetchurl, SDL2, SDL2_image, mesa, cmake, physfs, boost, zip, zlib
, pkgconfig, unzip}:
stdenv.mkDerivation rec {
  version = "1.0";
  name = "blobby-volley-${version}";

  src = fetchurl {
    url = "http://softlayer-ams.dl.sourceforge.net/project/blobby/Blobby%20Volley%202%20%28Linux%29/1.0/blobby2-linux-1.0.tar.gz";
    sha256 = "1qpmbdlyhfbrdsq4vkb6cb3b8mh27fpizb71q4a21ala56g08yms";
  };

  buildInputs = [SDL2 SDL2_image mesa cmake physfs boost zip zlib pkgconfig
    unzip];

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

  meta = {
    description = ''A blobby volleyball game'';
    license = stdenv.lib.licenses.bsd3;
    platforms = with stdenv.lib.platforms; linux;
    maintainers = with stdenv.lib.maintainers; [raskin];
    homepage = http://blobby.sourceforge.net/;
    downloadPage = "http://sourceforge.net/projects/blobby/files/Blobby%20Volley%202%20%28Linux%29/";
    inherit version;
  };
}
