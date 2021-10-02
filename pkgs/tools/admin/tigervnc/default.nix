{ lib, stdenv, fetchFromGitHub
, xorg, xkeyboard_config, zlib
, libjpeg_turbo, pixman, fltk
, cmake, gettext, libtool
, libGLU
, gnutls, pam, nettle
, xterm, openssh, perl
, makeWrapper
, nixosTests
}:

with lib;

stdenv.mkDerivation rec {
  version = "1.11.0";
  pname = "tigervnc";

  src = fetchFromGitHub {
    owner = "TigerVNC";
    repo = "tigervnc";
    rev = "v${version}";
    sha256 = "sha256-IX39oEhTyk7NV+9dD9mFtes22fBdMTAVIv5XkqFK560=";
  };


  postPatch = ''
    sed -i -e '/^\$cmd \.= " -pn";/a$cmd .= " -xkbdir ${xkeyboard_config}/etc/X11/xkb";' unix/vncserver/vncserver.in
    fontPath=
    substituteInPlace vncviewer/vncviewer.cxx \
       --replace '"/usr/bin/ssh' '"${openssh}/bin/ssh'
  '';

  dontUseCmakeBuildDir = true;

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
    "-DCMAKE_INSTALL_SBINDIR=${placeholder "out"}/bin"
    "-DCMAKE_INSTALL_LIBEXECDIR=${placeholder "out"}/bin"
  ];

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
      --prefix PATH : ${lib.makeBinPath (with xorg; [ xterm twm xsetroot xauth ]) }
  '';

  buildInputs = with xorg; [
    libjpeg_turbo fltk pixman
    gnutls pam nettle perl
    xorgproto
    utilmacros libXtst libXext libX11 libXext libICE libXi libSM libXft
    libxkbfile libXfont2 libpciaccess
    libGLU
  ] ++ xorg.xorgserver.buildInputs;

  nativeBuildInputs = with xorg; [ cmake zlib gettext libtool utilmacros fontutil makeWrapper ]
    ++ xorg.xorgserver.nativeBuildInputs;

  propagatedBuildInputs = xorg.xorgserver.propagatedBuildInputs;

  passthru.tests.tigervnc = nixosTests.vnc.testTigerVNC;

  meta = {
    homepage = "https://tigervnc.org/";
    license = lib.licenses.gpl2Plus;
    description = "Fork of tightVNC, made in cooperation with VirtualGL";
    maintainers = with lib.maintainers; [viric];
    platforms = with lib.platforms; linux;
    # Prevent a store collision.
    priority = 4;
  };
}
