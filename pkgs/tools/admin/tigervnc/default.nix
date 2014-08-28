{ stdenv, fetchurl, libX11, libXext, gettext, libICE, libXtst, libXi, libSM, xorgserver
, autoconf, automake, cvs, libtool, nasm, utilmacros, pixman, xkbcomp, xkeyboard_config
, fontDirectories, fontutil, libgcrypt, gnutls, pam, flex, bison
, fixesproto, damageproto, xcmiscproto, bigreqsproto, randrproto, renderproto
, fontsproto, videoproto, compositeproto, scrnsaverproto, resourceproto
, libxkbfile, libXfont, libpciaccess, cmake, libjpeg_turbo, libXft, fltk, libXinerama
, xineramaproto, libXcursor
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "1.3.1";
  name = "tigervnc-${version}";

  src = fetchurl {
    url = "https://github.com/TigerVNC/tigervnc/archive/v${version}.tar.gz";
    sha256 = "161bhibic777g47lbjgdnvjhkkdzxrzmxz9rw9sim3q0gcbp0vz3";
  };

  inherit fontDirectories;

  patchPhase = ''
    sed -i -e 's,$(includedir)/pixman-1,${if stdenv ? cross then pixman.crossDrv else pixman}/include/pixman-1,' unix/xserver/hw/vnc/Makefile.am
    sed -i -e '/^$pidFile/a$ENV{XKB_BINDIR}="${if stdenv ? cross then xkbcomp.crossDrv else xkbcomp}/bin";' unix/vncserver
    sed -i -e '/^\$cmd \.= " -pn";/a$cmd .= " -xkbdir ${if stdenv ? cross then xkeyboard_config.crossDrv else xkeyboard_config}/etc/X11/xkb";' unix/vncserver

    fontPath=
    for i in $fontDirectories; do
      for j in $(find $i -name fonts.dir); do
        addToSearchPathWithCustomDelimiter "," fontPath $(dirname $j)
      done
    done

    sed -i -e '/^\$cmd \.= " -pn";/a$cmd .= " -fp '"$fontPath"'";' unix/vncserver
  '';

  # I don't know why I can't use in the script
  # this:  ${concatStringsSep " " (map (f: "${f}") xorgserver.patches)}
  xorgPatches = xorgserver.patches;

  dontUseCmakeBuildDir = "yes";

  postBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -fpermissive -Wno-error=int-to-pointer-cast"

    # Build Xvnc
    tar xf ${xorgserver.src}
    cp -R xorg*/* unix/xserver
    pushd unix/xserver
    for a in $xorgPatches ../xserver114.patch
    do
      patch -p1 < $a
    done
    autoreconf -vfi
    ./configure $configureFlags --disable-xinerama --disable-xvfb --disable-xnest --disable-xorg --disable-dmx --disable-dri --disable-dri2 --disable-glx --prefix="$out" --disable-unit-tests
    make TIGERVNC_SRCDIR=`pwd`/../..
    popd
  '';

  postInstall = ''
    pushd unix/xserver
    make TIGERVNC_SRCDIR=`pwd`/../.. install
  '';

  crossAttrs = {
    buildInputs = (map (x : x.crossDrv) (buildInputs ++ [
      fixesproto damageproto xcmiscproto bigreqsproto randrproto renderproto
      fontsproto videoproto compositeproto scrnsaverproto resourceproto
      libxkbfile libXfont libpciaccess xineramaproto
    ]));
  };

  buildInputs =
    [ libX11 libXext gettext libICE libXtst libXi libSM libXft
      nasm libgcrypt gnutls pam pixman libjpeg_turbo fltk xineramaproto
      libXinerama libXcursor
    ];

  nativeBuildInputs =
    [ autoconf automake cvs utilmacros fontutil libtool flex bison
      cmake
    ]
      ++ xorgserver.nativeBuildInputs;

  propagatedNativeBuildInputs = xorgserver.propagatedNativeBuildInputs;

  meta = {
    homepage = http://www.tigervnc.org/;
    license = stdenv.lib.licenses.gpl2Plus;
    description = "Fork of tightVNC, made in cooperation with VirtualGL";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
