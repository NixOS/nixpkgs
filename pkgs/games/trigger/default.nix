{ lib, fetchurl, stdenv, runtimeShell, SDL2, freealut, SDL2_image, openal, physfs
, zlib, libGLU, libGL, glew, tinyxml-2, copyDesktopItems, makeDesktopItem }:

stdenv.mkDerivation rec {
  pname = "trigger-rally";
  version = "0.6.6.1";

  src = fetchurl {
    url = "mirror://sourceforge/trigger-rally/${pname}-${version}.tar.gz";
    sha256 = "016bc2hczqscfmngacim870hjcsmwl8r3aq8x03vpf22s49nw23z";
  };

  nativeBuildInputs = [ copyDesktopItems ];

  buildInputs = [
    SDL2
    freealut
    SDL2_image
    openal
    physfs
    zlib
    libGLU
    libGL
    glew
    tinyxml-2
  ];

  preConfigure = ''
    sed s,/usr/local,$out, -i bin/*defs

    cd src

    sed s,lSDL2main,lSDL2, -i GNUmakefile
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${SDL2.dev}/include/SDL2"
    export makeFlags="$makeFlags prefix=$out"
  '';

  enableParallelBuilding = true;

  postInstall = ''
    mkdir -p $out/bin
    cat <<EOF > $out/bin/trigger-rally
    #!${runtimeShell}
    exec $out/games/trigger-rally "$@"
    EOF
    chmod +x $out/bin/trigger-rally

    mkdir -p $out/share/pixmaps/
    ln -s $out/share/games/trigger-rally/icon/trigger-rally-icons.svg $out/share/pixmaps/trigger.svg
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Trigger";
      exec = "trigger-rally";
      icon = "trigger";
      desktopName = "Trigger";
      comment = "Fast-paced 3D single-player rally racing game";
      categories = [ "Game" "ActionGame" ];
    })
  ];

  meta = {
    description = "A fast-paced single-player racing game";
    mainProgram = "trigger-rally";
    homepage = "http://trigger-rally.sourceforge.net/";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [viric];
    platforms = with lib.platforms; linux;
  };
}
