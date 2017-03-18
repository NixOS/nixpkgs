{ fetchurl, stdenv, mesa, freeglut, libX11, plib, openal, freealut, libXrandr, xproto,
libXext, libSM, libICE, libXi, libXt, libXrender, libXxf86vm, openscenegraph, expat,
libpng, zlib, bash, SDL2, enet, libjpeg, cmake, pkgconfig, libvorbis}:

stdenv.mkDerivation rec {
  version = "2.2.1-r6404";
  name = "speed-dreams-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/speed-dreams/2.2.1/speed-dreams-src-base-${version}.tar.xz";
    sha256 = "0347sk8xbdsyvl48qybbycd7hvzsx5b37zzjx1yx73nzddhmlpbx";
  };

  cars-and-tracks = fetchurl {
    url = "mirror://sourceforge/speed-dreams/2.2.1/speed-dreams-src-hq-cars-and-tracks-${version}.tar.xz";
    sha256 = "1h50l110n42nrq6j3kcyhi3swgmrjcg979vb6h0zsf46afwv0z3q";
  };

  more-cars-and-tracks = fetchurl {
    url = "mirror://sourceforge/speed-dreams/2.2.1/speed-dreams-src-more-hq-cars-and-tracks-${version}.tar.xz";
    sha256 = "03m3gwd03jqgsfjdglzmrv613cp4gh50i63fwmnwl282zhxydcwd";
  };

  wip-cars-and-tracks = fetchurl {
    url = "mirror://sourceforge/speed-dreams/2.2.1/speed-dreams-src-wip-cars-and-tracks-${version}.tar.xz";
    sha256 = "0ysk756rd294xzpwvmjh0mb229ngzrc4ry9lpyhyak98rbcp9hxm";
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
      echo '#!${stdenv.shell}' >> "$out/bin/$(basename "$i")"
      echo "$i"' "$@"' >> "$out/bin/$(basename "$i")"
      chmod a+x "$out/bin/$(basename "$i")"
    done
  '';

  nativeBuildInputs = [ pkgconfig cmake ];

  buildInputs = [ libpng mesa freeglut libX11 plib openal freealut libXrandr xproto
    libXext libSM libICE libXi libXt libXrender libXxf86vm zlib bash expat
    SDL2 enet libjpeg openscenegraph libvorbis ];

  meta = {
    description = "Car racing game - TORCS fork with more experimental approach";
    homepage = http://speed-dreams.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric raskin];
    platforms = stdenv.lib.platforms.linux;
    hydraPlatforms = [];
  };
}
