{ stdenv, fetchurl, libX11, libXi, inputproto
, xproto, ncurses, pkgconfig, xorgserver, version, hash }:

stdenv.mkDerivation rec {
  name = "linuxwacom-${version}";
  
  src = fetchurl {
    url = "mirror://sourceforge/linuxwacom/${name}.tar.bz2";
    sha256 = hash;
  };
  
  buildInputs = [ libX11 libXi inputproto xproto ncurses pkgconfig xorgserver ];
  
  preConfigure = ''
    ./configure --enable-wacomdrv --prefix=$out \
      --with-xlib --with-xorg-sdk --enable-wacdump --enable-xsetwacom \
      --with-xmoduledir=$out/lib/xorg/modules/input
    mv configure configure.removed
  '';

  postInstall =
    ''
      ensureDir $out/etc/udev/rules.d
      cp ${./10-wacom.rules} $out/etc/udev/rules.d/10-wacom.rules
    '';

  meta = {
    maintainers = with stdenv.lib.maintainers; [raskin urkud];
    description = "Wacom digitizer driver for X11";
    homepage = http://linuxwacom.sourceforge.net;
  };
}
