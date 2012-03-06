{ stdenv, fetchurl, unzip, zlib, libpng, bzip2, SDL, SDL_mixer } :

let
  # This is the default "pakset" of objects, images, text, music, etc.
  pak64 = fetchurl {
    url = http://sourceforge.net/projects/simutrans/files/pak64/110-0-1/simupak64-110-0-1.zip/download;
    name = "pak64.zip";
    sha256 = "0gs6k9dbbhh60g2smsx2jza65vyss616bpngwpvilrvb5rzzrxcq";
  };

  # The source distribution seems to be missing some text files.
  # So we will get them from the binary Linux release (which apparently has them).
  langtab = fetchurl {
    url = http://sourceforge.net/projects/simutrans/files/simutrans/110-0-1/simulinux-110-0-1.zip/download;
    name = "simulinux-110-0-1.zip";
    sha256 = "15z13kazdzhfzwxry7a766xkkdzaidvscylzrjkx3nnbcq6461s4";
  };
in
stdenv.mkDerivation rec {
  pname = "simutrans";
  version = "110.0.1";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://github.com/aburch/simutrans/tarball/v110.0.1";
    name = "${name}.tar.gz";
    sha256 = "ab0e42e5013d6d2fd5d3176b39dc45e482583b3bad178aac1188bf2ec88feb51";
  };

  buildInputs = [ zlib libpng bzip2 SDL SDL_mixer unzip ];

  prePatch = ''
    # Use ~/.simutrans instead of ~/simutrans
    sed -i 's@%s/simutrans@%s/.simutrans@' simsys_s.cc
  '';

  preConfigure = ''
    # Configuration as per the readme.txt
    sed -i 's@#BACKEND = sdl@BACKEND = sdl@' config.template
    sed -i 's@#COLOUR_DEPTH = 16@COLOUR_DEPTH = 16@' config.template
    sed -i 's@#OSTYPE = linux@OSTYPE = linux@' config.template
    sed -i 's@#OPTIMISE = 1@OPTIMISE = 1@' config.template

    cp config.template config.default
  '';

  installPhase = ''
    # Erase the source distribution object definitions, will be replaced with langtab.
    rm -r simutrans

    # Default pakset and binary release core objects.
    unzip ${pak64}
    unzip ${langtab}

    mv sim simutrans/

    mkdir -p $out/simutrans
    cp -r simutrans $out

    mkdir -p $out/bin
    ln -s $out/simutrans/sim $out/bin/simutrans
  '';

  meta = {
    description = "Simutrans is a simulation game in which the player strives to run a successful transport system.";
    longDescription = ''
      Simutrans is a cross-platform simulation game in which the
      player strives to run a successful transport system by
      transporting goods, passengers, and mail between
      places. Simutrans is an open source remake of Transport Tycoon.
    '';

    homepage = http://www.simutrans.com/;
    license = "Artistic";
    maintainers = [ stdenv.lib.maintainers.kkallio ];
    platforms = stdenv.lib.platforms.linux;
  };
}
