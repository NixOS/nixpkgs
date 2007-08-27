{stdenv, fetchurl, SDL, SDL_mixer, zlib, libpng, unzip}:

stdenv.mkDerivation {
  name = "exult-1.2";
  builder = ./builder.sh;
  
  src = fetchurl {
    url = mirror://sourceforge/exult/exult-1.2.tar.gz;
    md5 = "0fc88dee74a91724d25373ba0a8670ba";
  };

  buildInputs = [SDL SDL_mixer zlib libpng unzip];
  
  NIX_CFLAGS_COMPILE = "-I${SDL_mixer}/include/SDL";
  
  # Digital recordings of the music on an original Roland MT-32.  So
  # we don't need actual MIDI playback capability.
  musicFiles = [
    (fetchurl {
      url = mirror://sourceforge/exult/U7MusicOGG_1of2.zip;
      md5 = "7746d1a9164fd67509107797496553bf";
    })
    (fetchurl {
      url = mirror://sourceforge/exult/U7MusicOGG_2of2.zip;
      md5 = "cdae5956d7c52f35e90317913a660123";
    })
  ];    

  meta = {
    description = "A reimplementation of the Ultima VII game engine";
  };
}
