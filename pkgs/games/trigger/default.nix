{ fetchurl, stdenv, runtimeShell, SDL2, freealut, SDL2_image, openal, physfs
, zlib, libGLU, libGL, glew, tinyxml-2 }:

stdenv.mkDerivation rec {
  pname = "trigger-rally";
  version = "0.6.6.1";

  src = fetchurl {
    url = "mirror://sourceforge/trigger-rally/${pname}-${version}.tar.gz";
    sha256 = "016bc2hczqscfmngacim870hjcsmwl8r3aq8x03vpf22s49nw23z";
  };

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
  '';

  meta = {
    description = "A fast-paced single-player racing game";
    homepage = "http://trigger-rally.sourceforge.net/";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
