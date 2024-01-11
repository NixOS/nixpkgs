{ lib, mkDerivation, fetchFromGitLab, cmake, luajit
, SDL2, SDL2_image, SDL2_ttf, physfs
, openal, libmodplug, libvorbis, libtiff, solarus, libxcb
, qt5, glm , gdb, fetchpatch}:

mkDerivation rec {
  pname = "solarus-quest-editor";
  version = "1.6.5";

  src = fetchFromGitLab {
    owner = "solarus-games";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-oOZ48JKz5s+97xZFy+FXi0KQOC0FBj61LjF25Uh7ct8=";
  };

  patches = [(fetchpatch {
    url = "https://gitlab.com/solarus-games/solarus-quest-editor/-/commit/88bc50d260ab93c4e36d4a32ded333c5e7b2226b.patch";
    sha256 = "sha256-rKPcWzBn7E+E7WgPgjlVQ5ipQPI2LIvoJKi7zE8YM20=";
  })];

  nativeBuildInputs = [ cmake qt5.qttools qt5.full];
  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
  ];


  # Custom post-install phase
  postInstall = ''
    # Copy the assets directory to the bin directory in the output path
    mkdir -p $out/bin
    cp -rv ../assets $out/bin/assets
    cp -rv ../assets $out/bin/assets/assets
  '';

  buildInputs = [
    SDL2
    SDL2_image
    SDL2_ttf
    glm
    libmodplug
    libvorbis
    qt5.full
    libxcb
    libtiff
    openal
    physfs
    qt5.qtbase
    qt5.qttools
    solarus
    luajit
    gdb
  ];



  meta = with lib; {
    description = "The editor for the Zelda-like ARPG game engine, Solarus";
    longDescription = ''
      Solarus is a game engine for Zelda-like ARPG games written in lua.
      Many full-fledged games have been writen for the engine.
      Games can be created easily using the editor.
    '';
    homepage = "https://www.solarus-games.org";
    license = licenses.gpl3;
    maintainers = [ ];
    platforms = platforms.linux;
  };

}
