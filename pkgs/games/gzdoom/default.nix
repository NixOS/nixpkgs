{ stdenv, fetchFromGitHub, cmake, makeWrapper, openal, fluidsynth_1
, soundfont-fluid, libGL, SDL2, bzip2, zlib, libjpeg, libsndfile, mpg123
, game-music-emu, pkgconfig }:

let
  zmusic-src = fetchFromGitHub {
    owner = "coelckers";
    repo = "zmusic";
    rev = "2d0ea861174f9e2031400ab29f5bcc8425521cc6";
    sha256 = "1ac7lhbzwfr0fsyv7n70hvb8imzngxn1qyanmv9j26j0h90hhl8a";
  };
  zmusic = stdenv.mkDerivation {
    pname = "zmusic";
    version = "1.1.0";

    src = zmusic-src;

    nativeBuildInputs = [ cmake pkgconfig ];

    preConfigure = ''
      sed -i \
        -e "s@/usr/share/sounds/sf2/@${soundfont-fluid}/share/soundfonts/@g" \
        -e "s@FluidR3_GM.sf2@FluidR3_GM2-2.sf2@g" \
        source/mididevices/music_fluidsynth_mididevice.cpp
    '';

  };

  gzdoom = stdenv.mkDerivation rec {
    pname = "gzdoom";
    version = "4.4.2";

    src = fetchFromGitHub {
      owner = "coelckers";
      repo = "gzdoom";
      rev = "g${version}";
      sha256 = "1xkkmbsdv64wyb9r2fv5mwyqw0bjryk528jghdrh47pndmjs9a38";
      fetchSubmodules = true;
    };

    nativeBuildInputs = [ cmake makeWrapper pkgconfig ];
    buildInputs = [
      SDL2
      libGL
      openal
      fluidsynth_1
      bzip2
      zlib
      libjpeg
      libsndfile
      mpg123
      game-music-emu
      zmusic
    ];

    enableParallelBuilding = true;

    NIX_CFLAGS_LINK = "-lopenal -lfluidsynth";

    installPhase = ''
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
    '';

    meta = with stdenv.lib; {
      homepage = "https://github.com/coelckers/gzdoom";
      description =
        "A Doom source port based on ZDoom. It features an OpenGL renderer and lots of new features";
      license = licenses.gpl3;
      platforms = [ "x86_64-linux" ];
      maintainers = with maintainers; [ lassulus ];
    };
  };

in gzdoom
