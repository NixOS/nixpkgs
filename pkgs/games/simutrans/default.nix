{ stdenv, fetchurl, unzip, zlib, libpng, bzip2, SDL, SDL_mixer, makeWrapper } :

let
  result = withPak (mkPak pak128);

  ver_1 = "112";
  ver_2 = "3";
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
    sha256 = "1ng963n2gvnwmsj73iy3gp9i5iqf5g6qk1gh1jnfm86gnjrsrq4m";
  };
  pak128 = fetchurl {
    url = "mirror://sourceforge/simutrans/pak128/pak128%20for%20${ver_1}/pak128-2.3.0--${ver_1}.2.zip";
    sha256 = "0jcif6mafsvpvxh1njyd6z2f6sab0fclq3f3nlg765yp3i1bfgff";
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
      sha256 = "0jdq2krfj3qsh8dks9ixsdvpyjq9yi80p58b0xjpsn35mkbxxaca";
    };

    # this resource is needed since 112.2 because the folders in simutrans directory has been removed from source code
    resources = fetchurl {
      url = "mirror://sourceforge/simutrans/simutrans/${ver_h2}/simulinux-${ver_h2}.zip";
      sha256 = "14ly341pdkr8r3cd0q49w424m79iz38iaxfi9l1yfcxl8idkga1c";
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
      unzip -o ${resources} -d $out/share/

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
