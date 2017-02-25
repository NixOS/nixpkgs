{ stdenv, fetchFromGitHub, xorg
, autoconf, automake, cvs, libtool, nasm, pixman, xkeyboard_config
, fontDirectories, libgcrypt, gnutls, pam, flex, bison, gettext
, cmake, libjpeg_turbo, fltk, nettle, libiconv, libtasn1
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "1.8.0pre20170211";
  name = "tigervnc-${version}";

  src = fetchFromGitHub {
    owner = "TigerVNC";
    repo = "tigervnc";
    sha256 = "10bs6394ya953gmak8g2d3n133vyfrryq9zq6dc27g8s6lw0mrbh";
    rev = "b6c46a1a99a402d5d17b1afafc4784ce0958d6ec";
  };

  inherit fontDirectories;

  patchPhase = ''
    sed -i -e 's,$(includedir)/pixman-1,${if stdenv ? cross then pixman.crossDrv else pixman}/include/pixman-1,' unix/xserver/hw/vnc/Makefile.am
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
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -Wno-error=int-to-pointer-cast -Wno-error=pointer-to-int-cast"
    export CXXFLAGS="$CXXFLAGS -fpermissive"
    # Build Xvnc
    tar xf ${xorg.xorgserver.src}
    cp -R xorg*/* unix/xserver
    pushd unix/xserver
    version=$(echo ${xorg.xorgserver.name} | sed 's/.*-\([0-9]\+\).\([0-9]\+\).*/\1\2/g')
    patch -p1 < ${src}/unix/xserver$version.patch
    autoreconf -vfi
    ./configure $configureFlags  --disable-devel-docs --disable-docs \
        --disable-xorg --disable-xnest --disable-xvfb --disable-dmx \
        --disable-xwin --disable-xephyr --disable-kdrive --with-pic \
        --disable-xorgcfg --disable-xprint --disable-static \
        --disable-composite --disable-xtrap --enable-xcsecurity \
        --disable-{a,c,m}fb \
        --disable-xwayland \
        --disable-config-dbus --disable-config-udev --disable-config-hal \
        --disable-xevie \
        --disable-dri --disable-dri2 --disable-dri3 --enable-glx \
        --enable-install-libxf86config \
        --prefix="$out" --disable-unit-tests \
        --with-xkb-path=${xkeyboard_config}/share/X11/xkb \
        --with-xkb-bin-directory=${xorg.xkbcomp}/bin \
        --with-xkb-output=$out/share/X11/xkb/compiled
    make TIGERVNC_SRCDIR=`pwd`/../..
    popd
  '';

  postInstall = ''
    pushd unix/xserver/hw/vnc
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
