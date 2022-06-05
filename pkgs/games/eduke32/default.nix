{ lib, stdenv, fetchurl, makeWrapper, pkg-config, nasm, makeDesktopItem
, alsa-lib, flac, gtk2, libvorbis, libvpx, libGLU, libGL
, SDL2, SDL2_mixer
, AGL, Cocoa, GLUT, OpenGL
}:

let
  desktopItem = makeDesktopItem {
    name = "eduke32";
    exec = "@out@/bin/${wrapper}";
    comment = "Duke Nukem 3D port";
    desktopName = "Enhanced Duke Nukem 3D";
    genericName = "Duke Nukem 3D port";
    categories = [ "Game" ];
  };

  wrapper = "eduke32-wrapper";

in stdenv.mkDerivation rec {
  pname = "eduke32";
  version = "20210910";
  rev = "9603";
  revExtra = "6c289cce4";

  src = fetchurl {
    url = "https://dukeworld.com/eduke32/synthesis/${version}-${rev}-${revExtra}/eduke32_src_${version}-${rev}-${revExtra}.tar.xz";
    sha256 = "sha256-/NQMsmT9z2N3KWBrP8hlGngQKJUgSP+vrNoFqJscRCk=";
  };

  buildInputs = [
    flac
    libvorbis
    libvpx
    SDL2
    SDL2_mixer
  ] ++ lib.optionals stdenv.isLinux [
    alsa-lib
    gtk2
    libGL
    libGLU
  ] ++ lib.optionals stdenv.isDarwin [
    AGL
    Cocoa
    GLUT
    OpenGL
  ];

  nativeBuildInputs = [ makeWrapper pkg-config ]
    ++ lib.optional (stdenv.hostPlatform.system == "i686-linux") nasm;

  postPatch = lib.optionalString stdenv.isLinux ''
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
  ] ++ lib.optionals stdenv.isDarwin [
    # broken, see: https://github.com/NixOS/nixpkgs/issues/19098
    "LTO=0"
  ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin eduke32 mapster32
  '' + lib.optionalString stdenv.isLinux ''
    makeWrapper $out/bin/eduke32 $out/bin/${wrapper} \
      --set-default EDUKE32_DATA_DIR /var/lib/games/eduke32 \
      --add-flags '-g "$EDUKE32_DATA_DIR/DUKE3D.GRP"'

    cp -rv ${desktopItem}/share $out
    substituteInPlace $out/share/applications/eduke32.desktop \
      --subst-var out
  '' + lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications/EDuke32.app/Contents/MacOS
    mkdir -p $out/Applications/Mapster32.app/Contents/MacOS

    cp -r platform/Apple/bundles/EDuke32.app/* $out/Applications/EDuke32.app/
    cp -r platform/Apple/bundles/Mapster32.app/* $out/Applications/Mapster32.app/

    ln -sf $out/bin/eduke32 $out/Applications/EDuke32.app/Contents/MacOS/eduke32
    ln -sf $out/bin/mapster32 $out/Applications/Mapster32.app/Contents/MacOS/mapster32
  '' + ''
    runHook postInstall
  '';

  meta = with lib; {
    description = "Enhanched port of Duke Nukem 3D for various platforms";
    homepage = "http://eduke32.com";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ mikroskeem sander ];
    platforms = platforms.all;
  };
}
