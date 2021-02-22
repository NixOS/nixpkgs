{ lib, stdenv, fetchurl
, # required for both
  unzip, zlib, curl, libjpeg, libpng, libvorbis, libtheora
, libogg, libmodplug
, # glx
  libX11, libGLU, libGL, libXpm, libXext, libXxf86vm, libXxf86dga, alsaLib
, # sdl
  SDL
}:

let
  version = "2.5.2";

  version_short = lib.replaceChars [ "." ] [ "" ] version;
in stdenv.mkDerivation {
  pname = "nexuiz";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/nexuiz/nexuiz-${version_short}.zip";
    sha256 = "0010jrxc68qqinkvdh1qn2b8z3sa5v1kcd8d1m4llp3pr6y7xqm5";
  };

  buildInputs = [
    # required for both
    unzip
    # glx
    libX11 libGLU libGL libXpm libXext libXxf86vm libXxf86dga alsaLib
    # sdl
    SDL
  ];

  postUnpack = ''
    cd Nexuiz/sources/
    unzip enginesource*.zip
    cd ../../
  '';

  NIX_LDFLAGS = ''
    -rpath ${zlib.out}/lib
    -rpath ${curl.out}/lib
    -rpath ${libjpeg.out}/lib
    -rpath ${libpng.out}/lib
    -rpath ${libvorbis.out}/lib
    -rpath ${libtheora.out}/lib
    -rpath ${libogg.out}/lib
    -rpath ${libmodplug.out}/lib
  '';

  buildPhase = ''
    cd sources/darkplaces/
    DP_FS_BASEDIR="$out/share/nexuiz"
    make DP_FS_BASEDIR=$DP_FS_BASEDIR cl-release
    make DP_FS_BASEDIR=$DP_FS_BASEDIR sdl-release
    make DP_FS_BASEDIR=$DP_FS_BASEDIR sv-release
    cd ../../
  '';

  installPhase = ''
    mkdir -pv "$out/bin/"
    cp -v sources/darkplaces/darkplaces-glx "$out/bin/nexuiz-glx"
    cp -v sources/darkplaces/darkplaces-sdl "$out/bin/nexuiz-sdl"
    cp -v sources/darkplaces/darkplaces-dedicated "$out/bin/nexuiz-dedicated"
    mkdir -pv "$out/share/nexuiz/"
    cp -rv data/ "$out/share/nexuiz/"
    ln -s "$out/bin/nexuiz-sdl" "$out/bin/nexuiz"
  '';

  dontPatchELF = true;

  meta = {
    description = "A free fast-paced first-person shooter";
    homepage = "http://www.alientrap.org/games/nexuiz";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}
