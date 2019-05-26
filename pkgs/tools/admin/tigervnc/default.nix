{ stdenv, fetchFromGitHub
, xorg, xkeyboard_config, zlib
, libjpeg_turbo, pixman, fltk
, fontDirectories
, cmake, gettext, libtool
, libGLU
, gnutls, pam, nettle
, xterm, openssh
, makeWrapper}:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "1.9.0";
  name = "tigervnc-${version}";

  src = fetchFromGitHub {
    owner = "TigerVNC";
    repo = "tigervnc";
    rev = "v1.9.0";
    sha256 = "0b47fg3741qs3zdpl2zr0s6jz46dypp2j6gqrappbzm3ywnnmm1x";
  };

  inherit fontDirectories;

  postPatch = ''
    sed -i -e '/^\$cmd \.= " -pn";/a$cmd .= " -xkbdir ${xkeyboard_config}/etc/X11/xkb";' unix/vncserver
    fontPath=
    for i in $fontDirectories; do
      for j in $(find $i -name fonts.dir); do
        addToSearchPathWithCustomDelimiter "," fontPath $(dirname $j)
      done
    done
    sed -i -e '/^\$cmd \.= " -pn";/a$cmd .= " -fp '"$fontPath"'";' unix/vncserver
    substituteInPlace vncviewer/vncviewer.cxx \
       --replace '"/usr/bin/ssh' '"${openssh}/bin/ssh'
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
        --enable-composite --disable-xtrap --enable-xcsecurity \
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
    make TIGERVNC_SRC=$src TIGERVNC_BUILDDIR=`pwd`/../.. -j$NIX_BUILD_CORES -l$NIX_BUILD_CORES
    popd
  '';

  postInstall = ''
    pushd unix/xserver/hw/vnc
    make TIGERVNC_SRC=$src TIGERVNC_BUILDDIR=`pwd`/../../../.. install
    popd
    rm -f $out/lib/xorg/protocol.txt

    wrapProgram $out/bin/vncserver \
      --prefix PATH : ${stdenv.lib.makeBinPath (with xorg; [ xterm twm xsetroot ]) }
  '';

  buildInputs = with xorg; [
    libjpeg_turbo fltk pixman
    gnutls pam nettle
    xorgproto
    utilmacros libXtst libXext libX11 libXext libICE libXi libSM libXft
    libxkbfile libXfont2 libpciaccess
    libGLU
  ] ++ xorg.xorgserver.buildInputs;

  nativeBuildInputs = with xorg; [ cmake zlib gettext libtool utilmacros fontutil makeWrapper ]
    ++ xorg.xorgserver.nativeBuildInputs;

  propagatedBuildInputs = xorg.xorgserver.propagatedBuildInputs;

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
