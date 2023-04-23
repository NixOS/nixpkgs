{ fetchurl, lib, stdenv, libGLU, libGL, freeglut, libX11, plib, openal, freealut, libXrandr, xorgproto,
libXext, libSM, libICE, libXi, libXt, libXrender, libXxf86vm, openscenegraph, expat,
libpng, zlib, bash, SDL2, enet, libjpeg, cmake, pkg-config, libvorbis, runtimeShell, curl }:

let
  version = "2.2.3-r7616";
  shortVersion = builtins.substring 0 5 version;
in
stdenv.mkDerivation rec {
  inherit version;
  pname = "speed-dreams";

  src = fetchurl {
    url = "mirror://sourceforge/speed-dreams/${shortVersion}/speed-dreams-src-base-${version}.tar.xz";
    sha256 = "sha256-GvB8SDZB9UivJSsQfMMon9N5MURdxTOwsaN4F0XQUCE=";
  };

  cars-and-tracks = fetchurl {
    url = "mirror://sourceforge/speed-dreams/${shortVersion}/speed-dreams-src-hq-cars-and-tracks-${version}.tar.xz";
    sha256 = "sha256-BuryCUvBD7rKmApCNsTkRN0UJ1q6P3sdYrSzpTqdTHc=";
  };

  more-cars-and-tracks = fetchurl {
    url = "mirror://sourceforge/speed-dreams/${shortVersion}/speed-dreams-src-more-hq-cars-and-tracks-${version}.tar.xz";
    sha256 = "sha256-GSCHYbJS352yAMczzss7tYSQXwLQV68rv/XkyGy+GoY=";
  };

  wip-cars-and-tracks = fetchurl {
    url = "mirror://sourceforge/speed-dreams/${shortVersion}/speed-dreams-src-wip-cars-and-tracks-${version}.tar.xz";
    sha256 = "sha256-r/IOSf+UZg2e+WIHn2QNDO6qQUhpIJvh7EF2jQ7lyyA=";
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
  '';

  # RPATH of binary /nix/store/.../lib64/games/speed-dreams-2/drivers/shadow_sc/shadow_sc.so contains a forbidden reference to /build/
  cmakeFlags = [ "-DCMAKE_SKIP_BUILD_RPATH=ON" ];

  nativeBuildInputs = [ pkg-config cmake ];

  buildInputs = [ libpng libGLU libGL freeglut libX11 plib openal freealut libXrandr xorgproto
    libXext libSM libICE libXi libXt libXrender libXxf86vm zlib bash expat
    SDL2 enet libjpeg openscenegraph libvorbis curl ];

  meta = {
    description = "Car racing game - TORCS fork with more experimental approach";
    homepage = "https://speed-dreams.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [raskin];
    platforms = lib.platforms.linux;
    hydraPlatforms = [];
  };
}
