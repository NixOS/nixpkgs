{ stdenv, fetchurl, SDL, SDL_mixer, zlib, libpng, unzip
, autoconf, automake, libtool, bison, flex
}:

stdenv.mkDerivation {
  name = "exult-1.4-pre-svn-20080712-0500";
  
  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://www.math.leidenuniv.nl/~wpalenst/cvs/exult-20080712-0500.tar.gz;
    sha256 = "186z8qb713yr1wfasfbpgz2wfqwmbh2d6lmgz1v8lhmwmfpkzgc4";
  };

  buildInputs = [
    SDL SDL_mixer zlib libpng unzip
    # The following are only needed because we're building from SVN.
    autoconf automake libtool bison flex
  ];
  
  NIX_CFLAGS_COMPILE = "-I${SDL_mixer}/include/SDL";

  preConfigure = ''
    ./autogen.sh
  '';
  
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
    homepage = http://exult.sourceforge.net/;
    description = "A reimplementation of the Ultima VII game engine (pre-release)";
  };
}
