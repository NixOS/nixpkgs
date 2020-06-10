{ lib, stdenv, fetchurl, pkgs, zip, ...}:

stdenv.mkDerivation rec {
  name = "xonotic";
  version = "0.8.2";

  #   src = fetchurl {
  #     url = "https://xonotic:g-23@beta.xonotic.org/autobuild/Xonotic-20200607.zip";
  #     sha256 = "1fw3sn3zn3b5ryrpjmsljy01qvbihnvz3zrmpxjv1mrcp9rh23dj";
  #   };
  src = fetchurl {
    url = "https://dl.xonotic.org/xonotic-0.8.2.zip";
    sha256 = "1mcs6l4clvn7ibfq3q69k2p0z6ww75rxvnngamdq5ic6yhq74bx2";
  };

  # TODO: libtheora libvorbisenc libogg
  # libpng16

  buildInputs = with pkgs; [ 
    unzip zip gmp SDL2 openssl which
    git bash zlib gcc
    libjpeg xorg.libXpm 
    xorg.libX11 libGLU 
    libGL xorg.libXext freetype
    xorg.libXxf86vm alsaLib 
    curl libvorbis libGL 
    libtheora libvorbis libogg 
    libpng pkg-config 
    stdenv.cc.cc autoPatchelfHook ];

  nativeBuildInputs = with pkgs; [
    zip 
  ];

  prePatch = ''
    patchShebangs source/qcsrc/tools
  '';

  buildPhase = ''
    export PATH=$PATH:$PWD/source/gmqcc/
    make all-zip-source -j $NIX_BUILD_CORES -l $NIX_BUILD_CORES
  '';

  installPhase = ''
    PREFIX="$out" make install
    cp key_0.d0pk "$out"/lib/xonotic/
  '';

  curl = pkgs.curl;
  libGL = pkgs.libGL;
  zlib = pkgs.zlib;
  gcc = pkgs.gcc;
  freetype = pkgs.freetype;
  libpng = pkgs.libpng;
  libtheora = pkgs.libtheora;
  libvorbis = pkgs.libvorbis;
  libogg = pkgs.libogg;

  # --add-needed ${gcc.out}/lib/libstdc++.so.6 \
  postFixup = ''
    patchelf \
        --add-needed ${curl.out}/lib/libcurl.so \
        --add-needed ${zlib.out}/lib/libz.so \
        $out/lib/xonotic/xonotic-linux64-dedicated
    patchelf \
        --add-needed ${curl.out}/lib/libcurl.so \
        --add-needed ${libvorbis.out}/lib/libvorbisfile.so \
        --add-needed ${libvorbis.out}/lib/libvorbis.so \
        --add-needed ${libGL.out}/lib/libGL.so \
        --add-needed ${zlib.out}/lib/libz.so \
        --add-needed ${libtheora.out}/lib/libtheora.so \
        --add-needed ${libtheora.out}/lib/libtheoraenc.so \
        --add-needed ${libtheora.out}/lib/libtheoradec.so \
        --add-needed ${libvorbis.out}/lib/libvorbisenc.so \
        --add-needed ${libpng.out}/lib/libpng16.so \
        --add-needed ${freetype.out}/lib/libfreetype.so \
        $out/lib/xonotic/xonotic-linux64-glx
    patchelf \
        --add-needed ${curl.out}/lib/libcurl.so \
        --add-needed ${libvorbis.out}/lib/libvorbisfile.so \
        --add-needed ${libvorbis.out}/lib/libvorbis.so \
        --add-needed ${libGL.out}/lib/libGL.so \
        --add-needed ${zlib.out}/lib/libz.so \
        --add-needed ${libtheora.out}/lib/libtheora.so \
        --add-needed ${libtheora.out}/lib/libtheoraenc.so \
        --add-needed ${libtheora.out}/lib/libtheoradec.so \
        --add-needed ${libvorbis.out}/lib/libvorbisenc.so \
        --add-needed ${libpng.out}/lib/libpng16.so \
         --add-needed ${freetype.out}/lib/libfreetype.so \
        $out/lib/xonotic/xonotic-linux64-sdl
  '';
}

