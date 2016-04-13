{ stdenv, fetchgit, xorg
, autoconf, automake, cvs, libtool, nasm, pixman, xkeyboard_config
, fontDirectories, libgcrypt, gnutls, pam, flex, bison, gettext
, cmake, libjpeg_turbo, fltk, nettle, libiconv, libtasn1
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "1.6.0";
  name = "tigervnc-${version}";

  src = fetchgit {
    url = "https://github.com/TigerVNC/tigervnc/";
    sha256 = "1plljv1cxsax88kv52g02n8c1hzwgp6j1p8z1aqhskw36shg4pij";
    rev = "5a727f25990d05c9a1f85457b45d6aed66409cb3";
  };

  inherit fontDirectories;

  patchPhase = ''
    sed -i -e 's,$(includedir)/pixman-1,${if stdenv ? cross then pixman.crossDrv else pixman}/include/pixman-1,' unix/xserver/hw/vnc/Makefile.am
    sed -i -e '/^$pidFile/a$ENV{XKB_BINDIR}="${if stdenv ? cross then xorg.xkbcomp.crossDrv else xorg.xkbcomp}/bin";' unix/vncserver
    sed -i -e '/^\$cmd \.= " -pn";/a$cmd .= " -xkbdir ${if stdenv ? cross then xkeyboard_config.crossDrv else xkeyboard_config}/etc/X11/xkb";' unix/vncserver
    fontPath=
    for i in $fontDirectories; do
      for j in $(find $i -name fonts.dir); do
        addToSearchPathWithCustomDelimiter "," fontPath $(dirname $j)
      done
    done
    sed -i -e '/^\$cmd \.= " -pn";/a$cmd .= " -fp '"$fontPath"'";' unix/vncserver
  '';

  dontUseCmakeBuildDir = true;

  postBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -Wno-error=int-to-pointer-cast"
    export CXXFLAGS="$CXXFLAGS -fpermissive"
    # Build Xvnc
    tar xf ${xorg.xorgserver.src}
    cp -R xorg*/* unix/xserver
    pushd unix/xserver
    autoreconf -vfi
    ./configure $configureFlags --disable-devel-docs --disable-docs --disable-xinerama --disable-xvfb --disable-xnest \
        --disable-xorg --disable-dmx --disable-dri --disable-dri2 --disable-glx \
        --prefix="$out" --disable-unit-tests \
        --with-xkb-path=${xkeyboard_config}/share/X11/xkb \
        --with-xkb-bin-directory=${xorg.xkbcomp}/bin \
        --with-xkb-output=$out/share/X11/xkb/compiled
    make TIGERVNC_SRCDIR=`pwd`/../..
    popd
  '';
  
  postInstall = ''
    pushd unix/xserver
    make TIGERVNC_SRCDIR=`pwd`/../.. install
    popd
    rm -f $out/lib/xorg/protocol.txt
  '';

  crossAttrs = {
    buildInputs = (map (x : x.crossDrv) (buildInputs ++ [
      xorg.fixesproto xorg.damageproto xorg.xcmiscproto xorg.bigreqsproto xorg.randrproto xorg.renderproto
      xorg.fontsproto xorg.videoproto xorg.compositeproto xorg.scrnsaverproto xorg.resourceproto
      xorg.libxkbfile xorg.libXfont xorg.libpciaccess xorg.xineramaproto
    ]));
  };

  buildInputs =
    [ xorg.libX11 xorg.libXext gettext xorg.libICE xorg.libXtst xorg.libXi xorg.libSM xorg.libXft
      nasm libgcrypt gnutls pam pixman libjpeg_turbo fltk xorg.xineramaproto
      xorg.libXinerama xorg.libXcursor nettle libiconv libtasn1
    ];

  nativeBuildInputs =
    [ autoconf automake cvs xorg.utilmacros xorg.fontutil libtool flex bison
      cmake gettext
    ]
      ++ xorg.xorgserver.nativeBuildInputs;

  propagatedNativeBuildInputs = xorg.xorgserver.propagatedNativeBuildInputs;

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.tigervnc.org/;
    license = stdenv.lib.licenses.gpl2Plus;
    description = "Fork of tightVNC, made in cooperation with VirtualGL";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
    # Prevent a store collision.
    priority = 4;
  };
}
