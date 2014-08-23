{ stdenv, fetchurl
, # required for both
  unzip, zlib, curl, libjpeg, libpng, libvorbis, libtheora
, libogg, libmodplug
, # glx
  libX11, mesa, libXpm, libXext, libXxf86vm, libXxf86dga, alsaLib
, # sdl
  SDL
}:

let
  version = "2.5.2";

  version_short = stdenv.lib.replaceChars [ "." ] [ "" ] "${version}";
in stdenv.mkDerivation {
  name = "nexuiz-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/nexuiz/nexuiz-${version_short}.zip";
    sha256 = "0010jrxc68qqinkvdh1qn2b8z3sa5v1kcd8d1m4llp3pr6y7xqm5";
  };

  buildInputs = [
    # required for both
    unzip
    # glx
    libX11 mesa libXpm libXext libXxf86vm libXxf86dga alsaLib
    # sdl
    SDL
  ];

  postUnpack = ''
    cd Nexuiz/sources/
    unzip enginesource*.zip
    cd ../../
  '';

  NIX_LDFLAGS = ''
    -rpath ${zlib}/lib
    -rpath ${curl}/lib
    -rpath ${libjpeg}/lib
    -rpath ${libpng}/lib
    -rpath ${libvorbis}/lib
    -rpath ${libtheora}/lib
    -rpath ${libogg}/lib
    -rpath ${libmodplug}/lib
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
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
