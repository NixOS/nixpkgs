{ stdenv, lib, fetchurl, dpkg, autoPatchelfHook
, glib, dbus, libX11, libGL, alsaLib, zlib, xorg, libxslt  
, libxml2, sqlite, libxcb, fontconfig, freetype, libGLU
, gtk2-x11, atk, gtk2, gdk-pixbuf, pango, cairo }:

stdenv.mkDerivation rec {
  pname = "leap-motion";
  version = "2.3.1";

  # non-free binaries
  src = fetchurl {
    url = "https://warehouse.leapmotion.com/apps/4186/download";
    sha256 = "1m3b029734yzhqbi78q36fi59xm9qrf05djshf059hq6ky9qahz0";
  };

  buildInputs = [
    glib
    dbus
    libGL
    libGLU
    alsaLib
    zlib
    stdenv.cc.cc.lib
    xorg.libXrender
    xorg.libXext
    xorg.libXi
    xorg.libSM
    xorg.libICE
    libX11
    libxslt
    libxml2
    sqlite
    libxcb
    fontconfig
    gtk2-x11
    atk
    gtk2
    gdk-pixbuf
    pango
    cairo
  ]; 

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  unpackPhase = ''
    tar xvf $src 
    dpkg-deb -x Leap_Motion_Installer_Packages_release_public_linux/Leap-*-x64.deb .
  '';

  installPhase = ''
    mkdir -p $out/share
    mkdir -p $out/bin/platforms
    mkdir -p $out/lib

    cp ./usr/lib/Leap/*       $out/lib
    cp ./usr/bin/*.so         $out/lib

    cp    ./usr/sbin/leapd           $out/bin
    cp    ./usr/bin/platforms/*      $out/bin/platforms
    cp    ./usr/bin/LeapControlPanel $out/bin
    cp    ./usr/bin/Recalibrate      $out/bin
    cp    ./usr/bin/Visualizer       $out/bin

    cp    ./usr/bin/Playground       $out/
    cp -r ./usr/bin/Playground_Data  $out/
    ln -s $out/Playground $out/bin/Playground

    addAutoPatchelfSearchPath $out/lib
    addAutoPatchelfSearchPath $out/bin
    autoPatchelf $out/

    cp -r ./usr/share/Leap $out/share/Leap
    cp -r ./lib/udev $out/lib/udev
  '';

  dontAutoPatchelf = true;
  dontStrip = true;

  meta = {
    homepage = https://www.leapmotion.com/;
    description = "Core software for the Leap Motion";
    license = stdenv.lib.licenses.unfree;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.noneucat ];
  };

}
