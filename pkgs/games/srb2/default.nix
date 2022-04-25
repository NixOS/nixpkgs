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
  version = "2.2.10";

  assets = fetchzip {
    name = "srb2-assets";
    url = "https://github.com/STJr/SRB2/releases/download/SRB2_release_${version}/SRB2-v${lib.replaceStrings ["."] [""] version}-Full.zip";
    sha256 = "sha256-SXMX2fbjPHEEcBaPr7r/2K5vg9Wy0N0krXQ96aSxY7c=";
    stripRoot = false;
    postFetch = ''
      rm $out/*.dll $out/*.exe $out/*.bat
    '';
  };

in stdenv.mkDerivation rec {
  pname = "srb2";
  inherit version;

  # There is also a GitHub mirror, but their own gitlab seems to be the main one
  # ...but assets are only published on GitHub
  src = fetchFromGitLab {
    domain = "git.do.srb2.org";
    owner = "STJr";
    repo = "SRB2";
    rev = "SRB2_release_${version}";
    sha256 = "sha256-7wWkTFsp0kT+tG5joAEVC1WI13v2WRN1yV40koBFaAw=";
  };

  postPatch = ''
    # '#include "SDL_thing.h"' -> '#include <SDL2/SDL_thing.h>'
    grep -Zlr '#include \+"SDL' src | xargs -0 sed -ie \
      's@#include \+"SDL\(_[a-zA-Z]\+\)\?.h"@#include <SDL2/SDL\1.h>@'
    sed -ie 's@<SDL.h>@<SDL2/SDL.h>@' src/sdl/i_threads.c

    # Change default assets location from FHS to the assets derivation
    sed -ie 's@/usr/local/share/games/SRB2@${assets}@' src/sdl/i_system.c
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
    # We add a reference to the assets derivation in postPatch
    "-DSRB2_ASSET_INSTALL=OFF"
    # Some includes are not detected automatically for some reason.
    "-DSDL2_INCLUDE_DIR=${SDL2}/include"
    "-DGME_INCLUDE_DIR=${libgme}/include"
    "-DOPENMPT_INCLUDE_DIR=${libopenmpt}/include"
  ];

  desktopItems = [ (makeDesktopItem {
    name = "srb2";
    desktopName = "Sonic Robo Blast 2";
    comment = meta.description;
    exec = "srb2";
    icon = "srb2";
    terminal = false;
    type = "Application";
    startupNotify = false;
    categories = [ "Application" "Game" ];
  }) ];

  postInstall = ''
    rm $out/lsdlsrb2
    mkdir -p $out/bin
    mv $out/lsdlsrb2-* $out/bin/srb2
    mkdir -p $out/share/srb2/doc
    mv $out/*.txt $out/share/srb2/doc/
    install -Dm644 ../src/sdl/SDL_icon.xpm $out/share/pixmaps/srb2.xpm
  '';

  meta = with lib; {
    homepage = "https://www.srb2.org/";
    downloadPage = "https://www.srb2.org/download/";
    description = "A free 3D Sonic the Hedgehog fangame closely inspired by the original Sonic games on the Sega Genesis";
    longDescription = ''
      Sonic Robo Blast 2 is a 3D open-source Sonic the Hedgehog fangame built
      using a modified version of the Doom Legacy port of Doom. SRB2 is closely
      inspired by the original Sonic games from the Sega Genesis, and attempts
      to recreate the design in 3D. While SRB2 isn't fully completed, it already
      features tons of levels, enemies, speed, and quite a lot of the fun that
      the original Sonic games provided.
    '';
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ fgaz ];
    # Requires SDL2_mixer on darwin, but SDL2_mixer is broken
    # (see comment in buildInputs)
    broken = stdenv.isDarwin;
  };
}
