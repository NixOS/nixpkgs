{stdenv, fetchurl, SDL, SDL_mixer, zlib, libpng, unzip}:

let

  # Digital recordings of the music on an original Roland MT-32.  So
  # we don't need actual MIDI playback capability.
  musicFiles =
    [ (fetchurl {
        url = mirror://sourceforge/exult/U7MusicOGG_1of2.zip;
        md5 = "7746d1a9164fd67509107797496553bf";
      })
      (fetchurl {
        url = mirror://sourceforge/exult/U7MusicOGG_2of2.zip;
        md5 = "cdae5956d7c52f35e90317913a660123";
      })
    ];

in

stdenv.mkDerivation {
  name = "exult-1.2";
  
  src = fetchurl {
    url = mirror://sourceforge/exult/exult-1.2.tar.gz;
    md5 = "0fc88dee74a91724d25373ba0a8670ba";
  };

  # Patches for building on x86_64 and gcc 4.x.
  patches = [
    (fetchurl {
      url = "http://www.rocklinux.net/sources/package/stf/exult/exult-gcc4.patch";
      sha256 = "1jlikxcpsi3yfchan3jbyi66fcyr18m7kfmsa946lwh3kzckszm7";
    })

    # From http://sources.gentoo.org/viewcvs.py/*checkout*/gentoo-x86/games-engines/exult/files/exult-1.2-64bits.patch?rev=1.1
    ./64bits.patch
  ];

  buildInputs = [SDL SDL_mixer zlib libpng unzip];
  
  NIX_CFLAGS_COMPILE = "-I${SDL_mixer}/include/SDL";

  postInstall =
    ''
      mkdir -p $out/share/exult/music
      for i in $musicFiles; do
          unzip -o -d $out/share/exult/music $i
      done
    '';
  
  meta = {
    homepage = http://exult.sourceforge.net/;
    description = "A reimplementation of the Ultima VII game engine";
    maintainers = [stdenv.lib.maintainers.eelco];
  };
}
