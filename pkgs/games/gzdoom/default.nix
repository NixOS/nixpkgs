{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, SDL2
, alsa-lib
, bzip2
, cmake
, copyDesktopItems
, fluidsynth
, game-music-emu
, gtk3
, libGL
, libjpeg
, libsndfile
, libvpx
, makeDesktopItem
, makeWrapper
, mpg123
, ninja
, openal
, openmp
, pkg-config
, soundfont-fluid
, vulkan-loader
, zlib
}:

let
  zmusic = stdenv.mkDerivation rec {
    pname = "zmusic";
    version = "1.1.11";

    src = fetchFromGitHub {
      owner = "ZDoom";
      repo = "ZMusic";
      rev = version;
      hash = "sha256-QvP8ranwBs8VupBie4vrHdm517OOpCuV3Rbjeb/L9PY=";
    };

    patches = [
      (fetchpatch {
        name = "system-fluidsynth.patch";
        url = "https://git.alpinelinux.org/aports/plain/testing/zmusic/system-fluidsynth.patch?id=59bac94da374cb01bc2a0e49d9e9287812fa1ac0";
        hash = "sha256-xKaqiNk1Kt9yNLB22IVmSEtGeOtxrCi7YtFCmhNr0MI=";
      })
    ];

    postPatch = ''
      substituteInPlace source/mididevices/music_fluidsynth_mididevice.cpp \
        --replace "/usr/share/sounds/sf2" "${soundfont-fluid}/share/soundfonts" \
        --replace "FluidR3_GM.sf2" "FluidR3_GM2-2.sf2"
    '';

    nativeBuildInputs = [
      cmake
      ninja
      pkg-config
    ];

    buildInputs = [
      alsa-lib
      fluidsynth
      libsndfile
      mpg123
      zlib
    ];
  };

  gzdoom = stdenv.mkDerivation rec {
    pname = "gzdoom";
    version = "4.10.0";

    src = fetchFromGitHub {
      owner = "ZDoom";
      repo = "gzdoom";
      rev = "g${version}";
      fetchSubmodules = true;
      hash = "sha256-F3p2X/hjPV9fuaA7T2bQTP6SlKcfc8GniJgv8BcopGw=";
    };

    outputs = [ "out" "doc" ];

    nativeBuildInputs = [
      cmake
      copyDesktopItems
      git
      makeWrapper
      ninja
      pkg-config
    ];

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
      openmp
      vulkan-loader
      zlib
      zmusic
    ];

    postPatch = ''
      substituteInPlace tools/updaterevision/UpdateRevision.cmake \
        --replace "ret_var(Tag)" "ret_var(\"${src.rev}\")" \
        --replace "ret_var(Timestamp)" "ret_var(\"1970-00-00 00:00:00 +0000\")" \
        --replace "ret_var(Hash)" "ret_var(\"${src.rev}\")"
    '';

    cmakeFlags = [
      "-DDYN_GTK=OFF"
      "-DDYN_OPENAL=OFF"
    ];

    desktopItems = [
      (makeDesktopItem {
        name = "gzdoom";
        exec = "gzdoom";
        desktopName = "GZDoom";
        categories = [ "Game" ];
      })
    ];

    postInstall = ''
      mv $out/bin/gzdoom $out/share/games/doom/gzdoom
      makeWrapper $out/share/games/doom/gzdoom $out/bin/gzdoom
    '';

    meta = with lib; {
      homepage = "https://github.com/ZDoom/gzdoom";
      description = "Modder-friendly OpenGL and Vulkan source port based on the DOOM engine";
      longDescription = ''
        GZDoom is a feature centric port for all DOOM engine games, based on
        ZDoom, adding an OpenGL renderer and powerful scripting capabilities.
      '';
      # https://github.com/ZDoom/ZMusic/tree/master/licenses
      # https://github.com/ZDoom/gzdoom/blob/master/LICENSE
      licenses = with licenses; [
        bsd
        free
        gpl3Plus
        lgpl21Plus
        lgpl3Plus
      ];
      platforms = [ "x86_64-linux" ];
      maintainers = with maintainers; [ azahi lassulus ];
    };
  };
in gzdoom
