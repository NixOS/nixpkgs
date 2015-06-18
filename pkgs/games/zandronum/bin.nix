{ stdenv
, atk
, bzip2
, cairo
, fetchurl
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
  name = "zandronum-2.0";
  src = fetchurl {
    url = "http://zandronum.com/downloads/zandronum2.0-linux-x86_64.tar.bz2";
    sha256 = "1k49az7x0ig40r2xisscpyhfcx9zzivx8w1l1ispj58g6qivicgc";
  };

  libPath = stdenv.lib.makeLibraryPath [
    atk
    bzip2
    cairo
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

  unpackPhase = ''
    tar xf $src
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share
    cp * $out/share

    patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux-x86-64.so.2 $out/share/zandronum
    patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux-x86-64.so.2 $out/share/zandronum-server

    cat > $out/bin/zandronum << EOF
    #!/bin/sh

    LD_LIBRARY_PATH=$libPath:$out/share $out/share/zandronum "\$@"
    EOF

    cat > $out/bin/zandronum-server << EOF
    #!/bin/sh

    LD_LIBRARY_PATH=$libPath:$out/share $out/share/zandronum-server "\$@"
    EOF

    chmod +x "$out/bin/zandronum"
    chmod +x "$out/bin/zandronum-server"
  '';

  meta = {
    homepage = http://zandronum.com/;
    description = "multiplayer oriented port, based off Skulltag, for Doom and Doom II by id Software. Binary version for online play.";
    maintainer = [ stdenv.lib.maintainers.lassulus ];
  };
}

