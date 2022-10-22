{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, makeWrapper, openal, fluidsynth
, soundfont-fluid, libGL, SDL2, bzip2, zlib, libjpeg, libsndfile, libvpx, mpg123
, game-music-emu, pkg-config, copyDesktopItems, makeDesktopItem, gtk3 }:

let
  zmusic = stdenv.mkDerivation rec {
    pname = "zmusic";
    version = "1.1.3";

    src = fetchFromGitHub {
      owner = "ZDoom";
      repo = "ZMusic";
      rev = version;
      hash = "sha256-wrNWfTIbNU/S2qFObUSkb6qyaceh+Y7Loxqudl86+W4=";
    };

    nativeBuildInputs = [ cmake pkg-config ];

    buildInputs = [ fluidsynth ];

    cmakeFlags = [ "-DDYN_FLUIDSYNTH=OFF" ];

    preConfigure = ''
      sed -i \
        -e "s@/usr/share/sounds/sf2/@${soundfont-fluid}/share/soundfonts/@g" \
        -e "s@FluidR3_GM.sf2@FluidR3_GM2-2.sf2@g" \
        source/mididevices/music_fluidsynth_mididevice.cpp
    '';
  };

  gzdoom = stdenv.mkDerivation rec {
    pname = "gzdoom";
    version = "4.8.2";

    src = fetchFromGitHub {
      owner = "ZDoom";
      repo = "gzdoom";
      rev = "g${version}";
      hash = "sha256-aT7DUZih3EDqncaXYIPIyGsz4fI267N29PmN3qyVjyo=";
      fetchSubmodules = true;
    };

    nativeBuildInputs = [ cmake makeWrapper pkg-config copyDesktopItems ];
    buildInputs = [
      SDL2
      bzip2
      fluidsynth
      game-music-emu
      gtk3
      libGL
      libjpeg
      libsndfile
      libvpx
      mpg123
      openal
      zlib
      zmusic
    ];

    patches = [
      (fetchpatch {  # TODO: Delete me when upgrading to 4.9
        url = "https://github.com/ZDoom/gzdoom/commit/aae85a1b9169953d8dcc5f138a477d5c7d75addb.patch";
        sha256 = "upuLDgVMaGaFSVaDV9Hj13DR5LUma51xv+Mfsz9m9a0=";
      })
    ];

    NIX_CFLAGS_LINK = "-lopenal -lfluidsynth";

    cmakeFlags = [ "-DDYN_GTK=OFF" ];

    desktopItems = [
      (makeDesktopItem {
        name = "gzdoom";
        exec = "gzdoom";
        desktopName = "GZDoom";
        categories = [ "Game" ];
      })
    ];

    installPhase = ''
      runHook preInstall

      install -Dm755 gzdoom "$out/lib/gzdoom/gzdoom"
      for i in *.pk3; do
        install -Dm644 "$i" "$out/lib/gzdoom/$i"
      done
      for i in fm_banks/*; do
        install -Dm644 "$i" "$out/lib/gzdoom/$i"
      done
      for i in soundfonts/*; do
        install -Dm644 "$i" "$out/lib/gzdoom/$i"
      done
      mkdir $out/bin
      makeWrapper $out/lib/gzdoom/gzdoom $out/bin/gzdoom

      runHook postInstall
    '';

    meta = with lib; {
      homepage = "https://github.com/ZDoom/gzdoom";
      description = "A Doom source port based on ZDoom. It features an OpenGL renderer and lots of new features";
      license = licenses.gpl3Plus;
      platforms = [ "x86_64-linux" ];
      maintainers = with maintainers; [ azahi lassulus ];
    };
  };
in gzdoom
