{ stdenv
, atk
, bzip2
, cairo
, fetchurl
, fluidsynth
, fontconfig
, freetype
, gdk_pixbuf
, glib
, gtk
, libjpeg_turbo
, mesa_glu
, mesa_noglu
, openssl
, pango
, SDL
, zlib
}:

stdenv.mkDerivation rec {
  name = "zandronum-2.1.2";

  src = fetchurl {
    url = "http://zandronum.com/downloads/zandronum2.1.2-linux-x86_64.tar.bz2";
    sha256 = "1f5aw2m8c0bl3lrvi2k3rrzq3q9x1ikxnxxjgh3k9qvanfn7ykbk";
  };

  libPath = stdenv.lib.makeLibraryPath [
    atk
    bzip2
    cairo
    fluidsynth
    fontconfig
    freetype
    gdk_pixbuf
    glib
    gtk
    libjpeg_turbo
    mesa_glu
    mesa_noglu
    openssl
    pango
    SDL
    stdenv.cc.cc
    zlib
  ];

  phases = [ "unpackPhase" "installPhase" ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/zandronum
    cp *.so *.pk3 zandronum zandronum-server $out/share/zandronum

    patchelf \
      --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) \
      --set-rpath $libPath:$out/share/zandronum \
      $out/share/zandronum/zandronum
    patchelf \
      --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) \
      --set-rpath $libPath \
      $out/share/zandronum/zandronum-server

    ln -s $out/share/zandronum/zandronum $out/bin/zandronum
    ln -s $out/share/zandronum/zandronum-server $out/bin/zandronum-server
  '';

  meta = {
    homepage = http://zandronum.com/;
    description = "multiplayer oriented port, based off Skulltag, for Doom and Doom II by id Software. Binary version for online play.";
    maintainer = [ stdenv.lib.maintainers.lassulus ];
    platforms = [ "x86_64-linux" ];
  };
}
