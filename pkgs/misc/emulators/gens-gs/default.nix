{ stdenv, fetchurl, pkgconfig, gtkLibs, SDL, nasm, zlib, libpng, mesa }:

stdenv.mkDerivation { 
  name = "gens-gs-7";

  src = fetchurl {
    url = http://segaretro.org/images/6/6d/Gens-gs-r7.tar.gz;
    sha256 = "1ha5s6d3y7s9aq9f4zmn9p88109c3mrj36z2w68jhiw5xrxws833";
  };

  buildInputs = [ pkgconfig gtkLibs.gtk SDL nasm zlib libpng mesa ];

  meta = {
    homepage = http://segaretro.org/Gens/GS;
    description = "A Genesis/Mega Drive emulator";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
