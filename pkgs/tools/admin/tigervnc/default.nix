{ lib
, stdenv
, fetchFromGitHub
, xorg
, xkeyboard_config
, zlib
, libjpeg_turbo
, pixman
, fltk
, cmake
, gettext
, libtool
, libGLU
, gnutls
, gawk
, pam
, nettle
, xterm
, openssh
, perl
, makeWrapper
, nixosTests
}:

stdenv.mkDerivation rec {
  version = "1.13.1";
  pname = "tigervnc";

  src = fetchFromGitHub {
    owner = "TigerVNC";
    repo = "tigervnc";
    rev = "v${version}";
    sha256 = "sha256-YSkgkk87bbHg7lJGoPBs7bfjvd1hvUeOZulFHYpXvvo=";
  };

  postPatch = lib.optionalString stdenv.isLinux ''
    sed -i -e '/^\$cmd \.= " -pn";/a$cmd .= " -xkbdir ${xkeyboard_config}/etc/X11/xkb";' unix/vncserver/vncserver.in
    fontPath=
    substituteInPlace vncviewer/vncviewer.cxx \
       --replace '"/usr/bin/ssh' '"${openssh}/bin/ssh'

    cp unix/xserver21.1.1.patch unix/xserver211.patch
    source_top="$(pwd)"
  '' + ''
    # On Mac, do not build a .dmg, instead copy the .app to the source dir
    gawk -i inplace 'BEGIN { del=0 } /hdiutil/ { del=2 } del<=0 { print } /$VERSION.dmg/ { del -= 1 }' release/makemacapp.in
    echo "mv \"\$APPROOT\" \"\$SRCDIR/\"" >> release/makemacapp.in
  '';

  dontUseCmakeBuildDir = true;

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
    "-DCMAKE_INSTALL_SBINDIR=${placeholder "out"}/bin"
    "-DCMAKE_INSTALL_LIBEXECDIR=${placeholder "out"}/bin"
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=array-bounds"
  ];

  postBuild = lib.optionalString stdenv.isLinux ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -Wno-error=int-to-pointer-cast -Wno-error=pointer-to-int-cast"
    export CXXFLAGS="$CXXFLAGS -fpermissive"
    # Build Xvnc
    tar xf ${xorg.xorgserver.src}
    cp -R xorg*/* unix/xserver
    pushd unix/xserver
    version=$(echo ${xorg.xorgserver.name} | sed 's/.*-\([0-9]\+\).\([0-9]\+\).*/\1\2/g')
    patch -p1 < "$source_top/unix/xserver$version.patch"
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
    make TIGERVNC_SRC=$src TIGERVNC_BUILDDIR=`pwd`/../.. -j$NIX_BUILD_CORES
    popd
  '' + lib.optionalString stdenv.isDarwin ''
    make dmg
  '';

  postInstall = lib.optionalString stdenv.isLinux ''
    pushd unix/xserver/hw/vnc
    make TIGERVNC_SRC=$src TIGERVNC_BUILDDIR=`pwd`/../../../.. install
    popd
    rm -f $out/lib/xorg/protocol.txt

    wrapProgram $out/bin/vncserver \
      --prefix PATH : ${lib.makeBinPath (with xorg; [ xterm twm xsetroot xauth ]) }
  '' + lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    mv 'TigerVNC Viewer ${version}.app' $out/Applications/
    rm $out/bin/vncviewer
    echo "#!/usr/bin/env bash
    open $out/Applications/TigerVNC\ Viewer\ ${version}.app --args \$@" >> $out/bin/vncviewer
    chmod +x $out/bin/vncviewer
  '';

  buildInputs = [
    fltk
    gnutls
    libjpeg_turbo
    pixman
    gawk
  ] ++ lib.optionals stdenv.isLinux (with xorg; [
    nettle
    pam
    perl
    xorgproto
    utilmacros
    libXtst
    libXext
    libX11
    libXext
    libICE
    libXi
    libSM
    libXft
    libxkbfile
    libXfont2
    libpciaccess
    libGLU
  ] ++ xorg.xorgserver.buildInputs
  );

  nativeBuildInputs = [
    cmake
    gettext
  ] ++ lib.optionals stdenv.isLinux (with xorg; [
    fontutil
    libtool
    makeWrapper
    utilmacros
    zlib
  ] ++ xorg.xorgserver.nativeBuildInputs);

  propagatedBuildInputs = lib.optional stdenv.isLinux xorg.xorgserver.propagatedBuildInputs;

  passthru.tests.tigervnc = nixosTests.tigervnc;

  meta = {
    homepage = "https://tigervnc.org/";
    license = lib.licenses.gpl2Plus;
    description = "Fork of tightVNC, made in cooperation with VirtualGL";
    maintainers = with lib.maintainers; [viric];
    platforms = lib.platforms.unix;
    # Prevent a store collision.
    priority = 4;
  };
}
