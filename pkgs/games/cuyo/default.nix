{ stdenv, fetchurl, SDL, SDL_mixer, zlib }:

stdenv.mkDerivation rec {
  name = "cuyo-${version}";
  version = "2.1.0";
  
  src = fetchurl {
     url = http://download.savannah.gnu.org/releases/cuyo/cuyo-2.1.0.tar.gz;
     sha256 = "17yqv924x7yvwix7yz9jdhgyar8lzdhqvmpvv0any8rdkajhj23c";
     };

  buildInputs = [ SDL SDL_mixer zlib ];
     
  meta = {
     homepage = http://karimmi.de/cuyo;
     description = "Stacking blocks game, with different rules for each level";
     license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
  
}
