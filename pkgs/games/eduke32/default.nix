{ stdenv, fetchurl, flac, gtk2, libvorbis, libvpx, makeDesktopItem, libGLU_combined, nasm
, pkgconfig, SDL2, SDL2_mixer }:

let
  year = "2015";
  date = "20150420";
  rev = "5160";
in stdenv.mkDerivation rec {
  name = "eduke32-${version}";
  version = "${date}-${rev}";

  src = fetchurl {
    url = "http://dukeworld.duke4.net/eduke32/synthesis/old/${year}/${version}/eduke32_src_${version}.tar.xz";
    sha256 = "1nlq5jbglg00c1z1vsyl627fh0mqfxvk5qyxav5vzla2b4svik2v";
  };

  buildInputs = [ flac gtk2 libvorbis libvpx libGLU_combined SDL2 SDL2_mixer ]
    ++ stdenv.lib.optional (stdenv.hostPlatform.system == "i686-linux") nasm;
  nativeBuildInputs = [ pkgconfig ];

  postPatch = ''
    substituteInPlace build/src/glbuild.c \
      --replace libGL.so	${libGLU_combined}/lib/libGL.so \
      --replace libGLU.so	${libGLU_combined}/lib/libGLU.so
  '';

  NIX_CFLAGS_COMPILE = "-I${SDL2.dev}/include/SDL2 -I${SDL2_mixer}/include/SDL2";
  NIX_LDFLAGS = "-L${SDL2}/lib";

  makeFlags = [
    "LINKED_GTK=1"
    "SDLCONFIG=${SDL2}/bin/sdl2-config"
    "VC_REV=${rev}"
  ];

  desktopItem = makeDesktopItem {
    name = "eduke32";
    exec = "eduke32-wrapper";
    comment = "Duke Nukem 3D port";
    desktopName = "Enhanced Duke Nukem 3D";
    genericName = "Duke Nukem 3D port";
    categories = "Application;Game;";
  };

  installPhase = ''
    # Make wrapper script
    cat > eduke32-wrapper <<EOF
    #!/bin/sh

    if [ "$EDUKE32_DATA_DIR" = "" ]; then
        EDUKE32_DATA_DIR=/var/lib/games/eduke32
    fi
    if [ "$EDUKE32_GRP_FILE" = "" ]; then
        EDUKE32_GRP_FILE=\$EDUKE32_DATA_DIR/DUKE3D.GRP
    fi

    cd \$EDUKE32_DATA_DIR
    exec $out/bin/eduke32 -g \$EDUKE32_GRP_FILE
    EOF

    # Install binaries
    mkdir -p $out/bin
    install -Dm755 eduke32{,-wrapper} mapster32 $out/bin

    # Install desktop item
    cp -rv ${desktopItem}/share $out
  '';

  meta = with stdenv.lib; {
    description = "Enhanched port of Duke Nukem 3D for various platforms";
    license = licenses.gpl2Plus;
    homepage = http://eduke32.com;
    maintainers = with maintainers; [ sander ];
    platforms = with platforms; linux;
  };
}
