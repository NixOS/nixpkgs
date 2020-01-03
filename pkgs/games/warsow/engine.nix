{ stdenv, lib, fetchurl, cmake, libogg, libvorbis, libtheora, curl, freetype
, libjpeg, libpng, SDL2, libGL, openal, zlib
}:

let
  # The game loads all those via dlopen().
  libs = lib.mapAttrs (name: x: lib.getLib x) {
    inherit zlib curl libpng libjpeg libogg libvorbis libtheora freetype;
  };

in stdenv.mkDerivation (libs // rec {
  name = "warsow-engine-${version}";
  version = "2.1.0";

  src = fetchurl {
    url = "http://slice.sh/warsow/warsow_21_sdk.tar.gz";
    sha256 = "0fj5k7qpf6far8i1xhqxlpfjch10zj26xpilhp95aq2yiz08pj4r";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    libogg libvorbis libtheora curl freetype libjpeg SDL2 libGL openal zlib
    libpng
  ];

  patches = [ ./libpath.patch ];
  postPatch = ''
    cd source/source
    substituteAllInPlace gameshared/q_arch.h
  '';

  cmakeFlags = [ "-DQFUSION_GAME=Warsow" ];

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p $out/lib
    cp -r libs $out/lib/warsow
    for i in warsow.* wsw_server.* wswtv_server.*; do
      install -Dm755 "$i" "$out/bin/''${i%.*}"
    done
  '';

  meta = with stdenv.lib; {
    description = "Multiplayer FPS game designed for competitive gaming (engine only)";
    homepage = http://www.warsow.net;
    license = licenses.gpl2;
    maintainers = with maintainers; [ astsmtl abbradar ];
    platforms = platforms.linux;
    broken = stdenv.isAarch64;
  };
})
