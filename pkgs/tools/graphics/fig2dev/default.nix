{ stdenv, fetchurl, zlib, libjpeg, libpng, xorg }:

stdenv.mkDerivation rec {
  name = "fig2dev-3.2.6a";
  src = fetchurl {
    url = https://sourceforge.net/projects/mcj/files/fig2dev-3.2.6a.tar.xz;
    sha256 = "19v72vvlri064s5f7s7id51m8nxn9gajvs4y36rv8ggqlkcs6qay";
  };

  buildInputs = [ zlib libjpeg libpng xorg.libXpm ];

  hardeningDisable = [ "format" ];

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
