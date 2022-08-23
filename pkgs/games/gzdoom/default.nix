{ lib, stdenv, fetchFromGitHub, cmake, makeWrapper, openal, fluidsynth
, soundfont-fluid, libGL, SDL2, bzip2, zlib, libjpeg, libsndfile, mpg123
, game-music-emu, pkg-config, copyDesktopItems, makeDesktopItem }:

let
  zmusic-src = fetchFromGitHub {
    owner = "coelckers";
    repo = "zmusic";
    rev = "bff02053bea30bd789e45f60b90db3ffc69c8cc8";
    sha256 = "0vpr79gpdbhslg5qxyd1qxlv5akgli26skm1vb94yd8v69ymdcy2";
  };
  zmusic = stdenv.mkDerivation {
    pname = "zmusic";
    version = "1.1.3";

    src = zmusic-src;

    nativeBuildInputs = [ cmake pkg-config ];

    preConfigure = ''
      sed -i \
        -e "s@/usr/share/sounds/sf2/@${soundfont-fluid}/share/soundfonts/@g" \
        -e "s@FluidR3_GM.sf2@FluidR3_GM2-2.sf2@g" \
        source/mididevices/music_fluidsynth_mididevice.cpp
    '';

  };

  gzdoom = stdenv.mkDerivation rec {
    pname = "gzdoom";
    version = "4.7.1";

    src = fetchFromGitHub {
      owner = "coelckers";
      repo = "gzdoom";
      rev = "g${version}";
      sha256 = "sha256-3wO83RgxzeJnoxykKQxb1S1GA6QZlhZMw6GrV3YEm/0=";
      fetchSubmodules = true;
    };

    nativeBuildInputs = [ cmake makeWrapper pkg-config copyDesktopItems ];
    buildInputs = [
      SDL2
      libGL
      openal
      fluidsynth
      bzip2
      zlib
      libjpeg
      libsndfile
      mpg123
      game-music-emu
      zmusic
    ];

    NIX_CFLAGS_LINK = "-lopenal -lfluidsynth";

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
      homepage = "https://github.com/coelckers/gzdoom";
      description =
        "A Doom source port based on ZDoom. It features an OpenGL renderer and lots of new features";
      license = licenses.gpl3;
      platforms = [ "x86_64-linux" ];
      maintainers = with maintainers; [ lassulus ];
    };
  };

in gzdoom
