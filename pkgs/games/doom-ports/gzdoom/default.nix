{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, makeDesktopItem
, copyDesktopItems
, SDL2
, bzip2
, cmake
, fluidsynth
, game-music-emu
, gtk3
, libGL
, libjpeg
, libsndfile
, libvpx
, mpg123
, ninja
, openal
, pkg-config
, vulkan-loader
, zlib
, zmusic
}:

stdenv.mkDerivation rec {
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
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ azahi lassulus ];
  };
}
