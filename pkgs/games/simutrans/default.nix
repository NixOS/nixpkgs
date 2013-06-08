{ stdenv, fetchurl, unzip, zlib, libpng, bzip2, SDL, SDL_mixer, makeWrapper } :

let
  result = withPak (mkPak pak128);

  ver_1 = "112";
  ver_2 = "1";
  ver_h2 = "${ver_1}-${ver_2}";

  # "pakset" of objects, images, text, music, etc.
  mkPak = src: stdenv.mkDerivation {
    name = "simutrans-pakset";
    inherit src;
    unpackPhase = "true";
    buildInputs = [ unzip ];
    installPhase = ''
      mkdir -p $out
      cd $out
      unzip ${src}
      mv simutrans/*/* .
      rm -rf simutrans
    '';
  };
  pak64 = fetchurl {
    url = "mirror://sourceforge/simutrans/pak64/${ver_h2}/simupak64-${ver_h2}.zip";
    sha256 = "1197rl2534wx9wdafarlr42qjw6pyghz4bynq2g68pi10h8csypw";
  };
  pak128 = fetchurl {
    url = "mirror://sourceforge/simutrans/pak128/pak128%20for%20${ver_1}/pak128-2.2.0--${ver_1}.0.zip";
    sha256 = "13rwv9q3fa3ac0k11ds7zkpd00k4mn14rb0cknknvyz46icb9n80";
  };

  withPak = pak: stdenv.mkDerivation {
    inherit (binaries) name;
    unpackPhase = "true";
    buildInputs = [ makeWrapper ];
    installPhase = ''makeWrapper "${binaries}/bin/simutrans" "$out/bin/simutrans" --add-flags -objects --add-flags "${pak}"'';
    inherit (binaries) meta;
  };

  binaries = stdenv.mkDerivation rec {
    pname = "simutrans";
    name = "${pname}-${ver_1}.${ver_2}";

    src = fetchurl {
      url = "mirror://sourceforge/simutrans/simutrans/${ver_h2}/simutrans-src-${ver_h2}.zip";
      sha256 = "1xrxpd5m2dc9bk8w21smfj28r41ji1qaihjwkwrifgz6rhg19l5c";
    };
    sourceRoot = ".";

    buildInputs = [ zlib libpng bzip2 SDL SDL_mixer unzip ];

    preConfigure = ''
      # Configuration as per the readme.txt
      sed \
        -e 's@#BACKEND = sdl@BACKEND = sdl@' \
        -e 's@#COLOUR_DEPTH = 16@COLOUR_DEPTH = 16@' \
        -e 's@#OSTYPE = linux@OSTYPE = linux@' \
        < config.template > config.default

      # Different default data dir
      sed -i -e 's:argv\[0\]:"'$out'/share/simutrans/":' \
        simmain.cc

      # Use ~/.simutrans instead of ~/simutrans ##not working
      #sed -i -e 's@%s/simutrans@%s/.simutrans@' simsys_s.cc

      # No optimization overriding
      sed -i -e '/-O$/d' Makefile
    '';

    installPhase = ''
      mkdir -p $out/share/
      mv simutrans $out/share/

      mkdir -p $out/bin/
      mv build/default/sim $out/bin/simutrans
    '';

    meta = {
      description = "A simulation game in which the player strives to run a successful transport system";
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
  };

in result
