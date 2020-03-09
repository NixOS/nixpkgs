{ stdenv, fetchurl, makeWrapper, pkgconfig, nasm, makeDesktopItem
, flac, gtk2, libvorbis, libvpx, libGLU, libGL
, SDL2, SDL2_mixer }:

let
  version = "20190330";
  rev = "7470";

  desktopItem = makeDesktopItem {
    name = "eduke32";
    exec = "@out@/bin/${wrapper}";
    comment = "Duke Nukem 3D port";
    desktopName = "Enhanced Duke Nukem 3D";
    genericName = "Duke Nukem 3D port";
    categories = "Application;Game;";
  };

  wrapper = "eduke32-wrapper";

in stdenv.mkDerivation {
  pname = "eduke32";
  inherit version;

  src = fetchurl {
    url = "http://dukeworld.duke4.net/eduke32/synthesis/latest/eduke32_src_${version}-${rev}.tar.xz";
    sha256 = "09a7l23i6sygicc82w1in9hjw0jvivlf7q0vw8kcx9j98lm23mkn";
  };

  buildInputs = [ flac gtk2 libvorbis libvpx libGL libGLU SDL2 SDL2_mixer ];

  nativeBuildInputs = [ makeWrapper pkgconfig ]
    ++ stdenv.lib.optional (stdenv.hostPlatform.system == "i686-linux") nasm;

  postPatch = ''
    substituteInPlace source/build/src/glbuild.cpp \
      --replace libGLU.so ${libGLU}/lib/libGLU.so

    for f in glad.c glad_wgl.c ; do
      substituteInPlace source/glad/src/$f \
        --replace libGL.so ${libGL}/lib/libGL.so
    done
  '';

  NIX_CFLAGS_COMPILE = "-I${SDL2.dev}/include/SDL2 -I${SDL2_mixer}/include/SDL2";

  makeFlags = [
    "SDLCONFIG=${SDL2}/bin/sdl2-config"
  ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin eduke32 mapster32

    makeWrapper $out/bin/eduke32 $out/bin/${wrapper} \
      --set-default EDUKE32_DATA_DIR /var/lib/games/eduke32 \
      --add-flags '-g "$EDUKE32_DATA_DIR/DUKE3D.GRP"'

    cp -rv ${desktopItem}/share $out
    substituteInPlace $out/share/applications/eduke32.desktop \
      --subst-var out

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Enhanched port of Duke Nukem 3D for various platforms";
    homepage = http://eduke32.com;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ sander ];
    # Darwin is untested (supported by upstream)
    platforms = platforms.all;
  };
}
