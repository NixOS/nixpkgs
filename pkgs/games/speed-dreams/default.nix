{ fetchurl, stdenv, libGLU, libGL, freeglut, libX11, plib, openal, freealut, libXrandr, xorgproto,
libXext, libSM, libICE, libXi, libXt, libXrender, libXxf86vm, openscenegraph, expat,
libpng, zlib, bash, SDL2, enet, libjpeg, cmake, pkgconfig, libvorbis, runtimeShell, curl }:

let
  version = "2.2.2-r6553";
  shortVersion = builtins.substring 0 5 version;
in
stdenv.mkDerivation rec {
  inherit version;
  pname = "speed-dreams";

  src = fetchurl {
    url = "mirror://sourceforge/speed-dreams/${shortVersion}/speed-dreams-src-base-${version}.tar.xz";
    sha256 = "1l47d2619kpfkvdwbkwr311qss6jjfwvgl5h9z2w3bwdgz0mbaij";
  };

  cars-and-tracks = fetchurl {
    url = "mirror://sourceforge/speed-dreams/${shortVersion}/speed-dreams-src-hq-cars-and-tracks-${version}.tar.xz";
    sha256 = "0l8ba5pzqqcfy4inyxy2lrrhhgfs43xab7fy751xz2xqpqpfksyq";
  };

  more-cars-and-tracks = fetchurl {
    url = "mirror://sourceforge/speed-dreams/${shortVersion}/speed-dreams-src-more-hq-cars-and-tracks-${version}.tar.xz";
    sha256 = "10w180mhhk6dw4cza6mqa0hp5qgym9lcizfwykqbgcvs01yl2yqb";
  };

  wip-cars-and-tracks = fetchurl {
    url = "mirror://sourceforge/speed-dreams/${shortVersion}/speed-dreams-src-wip-cars-and-tracks-${version}.tar.xz";
    sha256 = "1wad9yaydaryhyi7ckyaii124h0z7kziqgcl475a5jr7ggbxc24q";
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

  nativeBuildInputs = [ pkgconfig cmake ];

  buildInputs = [ libpng libGLU libGL freeglut libX11 plib openal freealut libXrandr xorgproto
    libXext libSM libICE libXi libXt libXrender libXxf86vm zlib bash expat
    SDL2 enet libjpeg openscenegraph libvorbis curl ];

  meta = {
    description = "Car racing game - TORCS fork with more experimental approach";
    homepage = "http://speed-dreams.sourceforge.net/";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [raskin];
    platforms = stdenv.lib.platforms.linux;
    hydraPlatforms = [];
  };
}
