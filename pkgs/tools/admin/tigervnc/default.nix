{ stdenv, fetchFromGitHub
, xorg, xkeyboard_config, zlib
, libjpeg_turbo, pixman, fltk
, fontDirectories
, cmake, gettext, libtool
, glproto, mesa_glu
, gnutls, pam, nettle
, xterm }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "1.8.0pre20170419";
  name = "tigervnc-${version}";

  src = fetchFromGitHub {
    owner = "TigerVNC";
    repo = "tigervnc";
    sha256 = "1y3fn7dwlkm7ilqn8bwyqj3bw7s7clnv7d4jml4wyvfihzz9j90b";
    rev = "v1.7.90";
  };

  inherit fontDirectories;

  patchPhase = ''
    sed -i -e '/^\$cmd \.= " -pn";/a$cmd .= " -xkbdir ${xkeyboard_config}/etc/X11/xkb";' unix/vncserver
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

    wrapProgram $out/bin/vncserver \
      --prefix PATH : ${stdenv.lib.makeBinPath (with xorg; [ xterm twm xsetroot ]) }
  '';

  buildInputs = with xorg; [
    libjpeg_turbo fltk pixman
    gnutls pam nettle
    fixesproto damageproto compositeproto randrproto
    xcmiscproto bigreqsproto randrproto renderproto
    fontsproto videoproto scrnsaverproto resourceproto presentproto
    utilmacros libXtst libXext libX11 libXext libICE libXi libSM libXft
    libxkbfile libXfont2 libpciaccess xineramaproto
    glproto mesa_glu
  ] ++ xorgserver.buildInputs;

  nativeBuildInputs = [ cmake zlib gettext libtool ] ++ xorg.xorgserver.nativeBuildInputs;

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
