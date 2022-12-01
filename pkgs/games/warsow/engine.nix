{ stdenv, lib, substituteAll, fetchurl, cmake, libogg, libvorbis, libtheora, curl, freetype
, libjpeg, libpng, SDL2, libGL, openal, zlib
}:

stdenv.mkDerivation rec {
  pname = "warsow-engine";
  version = "2.1.0";

  src = fetchurl {
    url = "http://slice.sh/warsow/warsow_21_sdk.tar.gz";
    sha256 = "0fj5k7qpf6far8i1xhqxlpfjch10zj26xpilhp95aq2yiz08pj4r";
  };

  patches = [
    (substituteAll {
      src = ./libpath.patch;
      inherit zlib curl libpng libjpeg libogg libvorbis libtheora freetype;
    })
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    libogg libvorbis libtheora curl freetype libjpeg SDL2 libGL openal zlib
    libpng
  ];

  # Workaround build failure on -fno-common toolchains:
  #   ld: CMakeFiles/wswtv_server.dir/__/unix/unix_time.c.o:(.bss+0x8): multiple definition of
  #     `c_pointcontents'; CMakeFiles/wswtv_server.dir/__/null/ascript_null.c.o:(.bss+0x8): first defined here
  NIX_CFLAGS_COMPILE = "-fcommon";

  cmakeFlags = [ "-DQFUSION_GAME=Warsow" ];

  preConfigure = ''
    cd source/source
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp -r libs $out/lib/warsow
    for i in warsow.* wsw_server.* wswtv_server.*; do
      install -Dm755 "$i" "$out/bin/''${i%.*}"
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "Multiplayer FPS game designed for competitive gaming (engine only)";
    homepage = "http://www.warsow.net";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ astsmtl abbradar ];
    platforms = platforms.linux;
    broken = stdenv.isAarch64;
  };
}
