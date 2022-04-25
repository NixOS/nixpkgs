{ lib
, stdenv
, fetchFromGitLab
, fetchzip
, cmake
, pkg-config
, nasm
, makeDesktopItem
, copyDesktopItems
, SDL2
, SDL2_mixer
, zlib
, libopenmpt
, libgme
, libpng
, curl
}:

let
  version = "1.3";

  assets = fetchzip {
    name = "srb2kart-assets";
    url = "https://github.com/STJr/Kart-Public/releases/download/v${version}/srb2kart-v${lib.replaceStrings ["."] [""] version}-Installer.exe";
    sha256 = "sha256-WDE7noJTy+JLsSh5ETcTFe1b4jz2RgZ/zuYFkQ2U+w8=";
    extension = "zip";
    stripRoot = false;
    postFetch = ''
      rm $out/*.dll $out/*.exe $out/*.bat
    '';
  };

in stdenv.mkDerivation rec {
  pname = "srb2kart";
  inherit version;

  # There is also a GitHub mirror, but their own gitlab seems to be the main one
  # ...but assets are only published on GitHub
  src = fetchFromGitLab {
    domain = "git.do.srb2.org";
    owner = "KartKrew";
    repo = "Kart-Public";
    rev = "v${version}";
    sha256 = "sha256-iXh0RPnt6Zzt8aj+HX4dHU57Qft+ME0n+BvGxOpKL4w=";
  };

  patches = [
    # We add a reference to the assets derivation in postPatch
    # TODO send upstream a patch to add SRB2_ASSET_INSTALL here too
    ./dont-install-assets.patch
  ];

  postPatch = ''
    # '#include "SDL_thing.h"' -> '#include <SDL2/SDL_thing.h>'
    grep -Zlr '#include \+"SDL' src | xargs -0 sed -ie \
      's@#include \+"SDL\(_[a-zA-Z]\+\)\?.h"@#include <SDL2/SDL\1.h>@'
    sed -ie 's@<SDL.h>@<SDL2/SDL.h>@' src/sdl/i_threads.c

    # Change default assets location from FHS to the assets derivation
    sed -ie 's@/usr/local/share/games/SRB2Kart@${assets}@' src/sdl/i_system.c
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    nasm
    copyDesktopItems
  ];

  buildInputs = [
    SDL2
    # Adding the optional SDL2_mixer dependency results in an error:
    #   In file included from /build/source/src/sdl/mixer_sound.c:55:
    #   /nix/store/...-SDL2_mixer-2.0.4/include/SDL2/SDL_mixer.h:25:10:
    #     fatal error: SDL_stdinc.h: No such file or directory
    #     25 | #include "SDL_stdinc.h"
    #SDL2_mixer
    zlib
    libopenmpt
    libgme
    libpng
    curl
  ];

  cmakeFlags = [
    "-DSRB2_ASSET_DIRECTORY=${assets}"
    # Some includes are not detected automatically for some reason.
    "-DSDL2_INCLUDE_DIR=${SDL2}/include"
    "-DGME_INCLUDE_DIR=${libgme}/include"
    "-DOPENMPT_INCLUDE_DIR=${libopenmpt}/include"
  ];

  desktopItems = [ (makeDesktopItem {
    name = "srb2kart";
    desktopName = "Sonic Robo Blast 2 Kart";
    comment = meta.description;
    exec = "srb2kart";
    icon = "srb2kart";
    terminal = false;
    type = "Application";
    startupNotify = false;
    categories = [ "Application" "Game" ];
  }) ];

  postInstall = ''
    rm $out/srb2kart
    mkdir -p $out/bin
    mv $out/srb2kart-* $out/bin/srb2kart
    mkdir -p $out/share/srb2kart/doc
    mv $out/*.txt $out/share/srb2kart/doc/
    install -Dm644 ../src/sdl/SDL_icon.xpm $out/share/pixmaps/srb2kart.xpm
  '';

  meta = with lib; {
    homepage = "https://wiki.srb2.org/wiki/SRB2Kart";
    downloadPage = "https://github.com/STJr/Kart-Public/releases/";
    description = "A kart racing mod based on the 3D Sonic the Hedgehog fangame Sonic Robo Blast 2";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ fgaz ];
    # Requires SDL2_mixer on darwin, but SDL2_mixer is broken
    # (see comment in buildInputs)
    broken = stdenv.isDarwin;
  };
}
