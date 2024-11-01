{ fetchurl, lib, stdenv, libGLU, libGL, libglut, libX11, plib, openal, freealut, libXrandr, xorgproto,
libXext, libSM, libICE, libXi, libXt, libXrender, libXxf86vm, openscenegraph, expat,
libpng, zlib, bash, SDL2, SDL2_mixer, enet, libjpeg, cmake, pkg-config, libvorbis, runtimeShell, curl, copyDesktopItems, makeDesktopItem }:

let
  version = "2.3.0-r8786";
  shortVersion = builtins.substring 0 5 version;
in
stdenv.mkDerivation rec {
  inherit version;
  pname = "speed-dreams";

  src = fetchurl {
    url = "mirror://sourceforge/speed-dreams/${shortVersion}/speed-dreams-src-base-${version}.tar.xz";
    sha256 = "sha256-DUyMs9Hr1PYgmNVwBY/e6snVeGl9GX0AnZ7S+TFABKQ=";
  };

  cars-and-tracks = fetchurl {
    url = "mirror://sourceforge/speed-dreams/${shortVersion}/speed-dreams-src-hq-cars-and-tracks-${version}.tar.xz";
    sha256 = "sha256-WT+W6uuw4BRSbF1Cw123q3v9qSCvBQ7TcQ/Y0RV/7Js=";
  };

  more-cars-and-tracks = fetchurl {
    url = "mirror://sourceforge/speed-dreams/${shortVersion}/speed-dreams-src-more-hq-cars-and-tracks-${version}.tar.xz";
    sha256 = "sha256-psApv+Z1HDFvh5bzt125mo/ZvO5rjee/KhOf45iKnKk=";
  };

  wip-cars-and-tracks = fetchurl {
    url = "mirror://sourceforge/speed-dreams/${shortVersion}/speed-dreams-src-wip-cars-and-tracks-${version}.tar.xz";
    sha256 = "sha256-OEAbqFfO2PzHP7+eAtPNn3Ql6fYNTKzzQW8lHe9KDXM=";
  };

  sourceRoot = ".";

  postUnpack = ''
    echo Unpacking data
    tar -xf ${cars-and-tracks}
    tar -xf ${more-cars-and-tracks}
    tar -xf ${wip-cars-and-tracks}
  '';

  preBuild = ''
    make -C src/libs/portability
    make -C src/libs/portability portability.o
    ar -rv "$(echo lib*/games/speed-dreams*/lib)"/libportability_static.a src/libs/portability/CMakeFiles/portability.dir/portability.cpp.o
    export NIX_LDFLAGS="$NIX_LDFLAGS -L$(echo $PWD/lib*/games/speed-dreams*/lib) -lexpat"
    echo "libportability_static.a built"
  '';

  postInstall = ''
    mkdir "$out/bin"
    for i in "$out"/games/*; do
      echo '#!${runtimeShell}' >> "$out/bin/$(basename "$i")"
      echo "$i"' "$@"' >> "$out/bin/$(basename "$i")"
      chmod a+x "$out/bin/$(basename "$i")"
    done

    mkdir -p $out/share/pixmaps/
    ln -s "$out/share/games/speed-dreams-2/data/icons/icon.png" "$out/share/pixmaps/speed-dreams-2.png"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Speed Dreams 2";
      exec = "speed-dreams-2";
      icon = "speed-dreams-2.png";
      desktopName = "speed-dreams-2";
      comment = "The Open Racing Car Simulator Fork";
      categories = [ "Application" "Game" ];
    })
  ];

  # RPATH of binary /nix/store/.../lib64/games/speed-dreams-2/drivers/shadow_sc/shadow_sc.so contains a forbidden reference to /build/
  cmakeFlags = [ "-DCMAKE_SKIP_BUILD_RPATH=ON" ];

  nativeBuildInputs = [ pkg-config cmake copyDesktopItems ];

  buildInputs = [ libpng libGLU libGL libglut libX11 plib openal freealut libXrandr xorgproto
    libXext libSM libICE libXi libXt libXrender libXxf86vm zlib bash expat
    SDL2 SDL2_mixer enet libjpeg openscenegraph libvorbis curl ];

  meta = {
    description = "Car racing game - TORCS fork with more experimental approach";
    homepage = "https://speed-dreams.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [raskin];
    platforms = lib.platforms.linux;
    hydraPlatforms = [];
  };
}
