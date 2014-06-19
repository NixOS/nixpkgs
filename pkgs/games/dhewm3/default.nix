{stdenv, fetchurl, unzip, cmake, SDL, mesa, zlib, libjpeg, libogg, libvorbis
, openalSoft, curl }:

stdenv.mkDerivation rec {
  hash = "92a41322f4aa8bd45395d8088721c9a2bf43c79b";
  name = "dhewm3-20130113-${hash}";
  src = fetchurl {
    url = "https://github.com/dhewm/dhewm3/zipball/${hash}";
    sha256 = "0c17k60xhimpqi1xi9s1l7jbc97pqjnk4lgwyjb0agc3dkr73zwd";
  };

  # Add mesa linking
  patchPhase = ''
    sed -i 's/\<idlib\()\?\)$/idlib GL\1/' CMakeLists.txt
  '';

  unpackPhase = ''
    unzip ${src}
    cd */neo
  '';

  buildInputs = [ unzip cmake SDL mesa zlib libjpeg libogg libvorbis openalSoft
    curl ];

  enableParallelBuilding = true;

  meta = {
    homepage = https://github.com/dhewm/dhewm3;
    description = "Doom 3 port to SDL";
    license = stdenv.lib.licenses.gpl3;
  };

}
