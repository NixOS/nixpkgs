{ stdenv, fetchurl
, # required for both
  unzip, libjpeg, zlib, libvorbis, curl, patchelf
, # glx
  libX11, libGLU_combined, libXpm, libXext, libXxf86vm, alsaLib
, # sdl
  SDL2
}:

stdenv.mkDerivation rec {
  name = "xonotic-0.8.2";

  src = fetchurl {
    url = "http://dl.xonotic.org/${name}.zip";
    sha256 = "1mcs6l4clvn7ibfq3q69k2p0z6ww75rxvnngamdq5ic6yhq74bx2";
  };

  buildInputs = [
    # required for both
    unzip libjpeg
    # glx
    libX11 libGLU_combined libXpm libXext libXxf86vm alsaLib
    # sdl
    SDL2
    zlib libvorbis curl
  ];

  sourceRoot = "Xonotic/source/darkplaces";

  # "debug", "release", "profile"
  target = "release";

  dontStrip = target != "release";

  buildPhase = ''
    DP_FS_BASEDIR="$out/share/xonotic"
    make DP_FS_BASEDIR=$DP_FS_BASEDIR cl-${target}
    make DP_FS_BASEDIR=$DP_FS_BASEDIR sdl-${target}
    make DP_FS_BASEDIR=$DP_FS_BASEDIR sv-${target}
  '';
  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p "$out/bin"
    cp darkplaces-dedicated "$out/bin/xonotic-dedicated"
    cp darkplaces-sdl "$out/bin/xonotic-sdl"
    cp darkplaces-glx "$out/bin/xonotic-glx"
    cd ../..
    mkdir -p "$out/share/xonotic"
    mv data "$out/share/xonotic"

    # default to sdl
    ln -s "$out/bin/xonotic-sdl" "$out/bin/xonotic"
  '';

  # Xonotic needs to find libcurl.so at runtime for map downloads
  dontPatchELF = true;
  postFixup = ''
    patchelf --add-needed ${curl.out}/lib/libcurl.so $out/bin/xonotic-dedicated
    patchelf \
        --add-needed ${curl.out}/lib/libcurl.so \
        --add-needed ${libvorbis}/lib/libvorbisfile.so \
        --add-needed ${libvorbis}/lib/libvorbis.so \
        $out/bin/xonotic-glx
    patchelf \
        --add-needed ${curl.out}/lib/libcurl.so \
        --add-needed ${libvorbis}/lib/libvorbisfile.so \
        --add-needed ${libvorbis}/lib/libvorbis.so \
        $out/bin/xonotic-sdl
  '';

  meta = {
    description = "A free fast-paced first-person shooter";
    longDescription = ''
      Xonotic is a free, fast-paced first-person shooter that works on
      Windows, macOS and Linux. The project is geared towards providing
      addictive arena shooter gameplay which is all spawned and driven
      by the community itself. Xonotic is a direct successor of the
      Nexuiz project with years of development between them, and it
      aims to become the best possible open-source FPS of its kind.
    '';
    homepage = http://www.xonotic.org;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ astsmtl zalakain ];
    platforms = stdenv.lib.platforms.linux;
    hydraPlatforms = [];
  };
}
