{ stdenv, fetchurl, cmake, boost, SDL2, python2, freetype, openal, libogg, libvorbis, zlib, libpng, libtiff, libjpeg, mesa, glew, doxygen
, libxslt, makeWrapper }:

stdenv.mkDerivation rec {
  version = "0.4.7.1_2017-09-03";
  name = "freeorion-${version}";

  src = fetchurl {
    url = "https://github.com/freeorion/freeorion/releases/download/v0.4.7.1/FreeOrion_v0.4.7.1_2017-09-03.139ffd9_Source.tar.gz";
    sha256 = "0cd11yd93x4mybxhl0mwxpc3a65d8n8l6n53jldk4ilf64iy3b0m";
  };

  buildInputs = [ cmake boost SDL2 python2 freetype openal libogg libvorbis zlib libpng libtiff libjpeg mesa glew doxygen makeWrapper ];

  patches = [
    ./fix_rpaths.patch
  ];

  enableParallelBuilding = true;

  postInstall = ''
    mkdir -p $out/fixpaths
    # We need final slashes for XSLT replace to work properly
    substitute ${./fix-paths.xslt} $out/fixpaths/fix-paths.xslt \
      --subst-var-by nixStore "$NIX_STORE/" \
      --subst-var-by out "$out/"
    substitute ${./fix-paths.sh} $out/fixpaths/fix-paths \
      --subst-var-by libxsltBin ${libxslt.bin} \
      --subst-var out
    chmod +x $out/fixpaths/fix-paths

    wrapProgram $out/bin/freeorion \
      --run $out/fixpaths/fix-paths
  '';

  meta = with stdenv.lib; {
    description = "A free, open source, turn-based space empire and galactic conquest (4X) computer game";
    homepage = http://www.freeorion.org;
    license = [ licenses.gpl2 licenses.cc-by-sa-30 ];
    platforms = platforms.linux;
  };
}
