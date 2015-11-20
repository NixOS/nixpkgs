{ stdenv, fetchurl
, # required for both
  unzip, libjpeg, zlib, libvorbis, curl
, # glx
  libX11, mesa, libXpm, libXext, libXxf86vm, alsaLib
, # sdl
  SDL
}:

stdenv.mkDerivation rec {
  name = "xonotic-0.8.1";

  src = fetchurl {
    url = "http://dl.xonotic.org/${name}.zip";
    sha256 = "0vy4hkrbpz9g91gb84cbv4xl845qxaknak6hshk2yflrw90wr2xy";
  };

  buildInputs = [
    # required for both
    unzip libjpeg
    # glx
    libX11 mesa libXpm libXext libXxf86vm alsaLib
    # sdl
    SDL
  ];

  sourceRoot = "Xonotic/source/darkplaces";

  #patchPhase = ''
  #  substituteInPlace glquake.h \
  #    --replace 'typedef char GLchar;' '/*typedef char GLchar;*/'
  #'';

  NIX_LDFLAGS = ''
    -rpath ${zlib.out}/lib
    -rpath ${libvorbis.out}/lib
    -rpath ${curl.out}/lib
  '';

  buildPhase = ''
    DP_FS_BASEDIR="$out/share/xonotic"
    make DP_FS_BASEDIR=$DP_FS_BASEDIR cl-release
    make DP_FS_BASEDIR=$DP_FS_BASEDIR sdl-release
    make DP_FS_BASEDIR=$DP_FS_BASEDIR sv-release
  '';

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

  dontPatchELF = true;

  meta = {
    description = "A free fast-paced first-person shooter";
    longDescription = ''
      Xonotic is a free, fast-paced first-person shooter that works on
      Windows, OS X and Linux. The project is geared towards providing
      addictive arena shooter gameplay which is all spawned and driven
      by the community itself. Xonotic is a direct successor of the
      Nexuiz project with years of development between them, and it
      aims to become the best possible open-source FPS of its kind.
    '';
    homepage = http://www.xonotic.org;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ astsmtl ];
    platforms = stdenv.lib.platforms.linux;
    hydraPlatforms = [];
  };
}
