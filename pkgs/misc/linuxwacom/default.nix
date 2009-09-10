{ stdenv, fetchurl, libX11, libXi, inputproto
, xproto, ncurses, pkgconfig, xorgserver }:

stdenv.mkDerivation rec {
  name = "linuxwacom-0.8.4-1";
  
  src = fetchurl {
    url = "mirror://sourceforge/linuxwacom/${name}.tar.bz2";
    sha256 = "1gfsjm9i1c8d0w0g8v9q3xfrpxsmmsc9qlidr5mkwidr070cphz9";
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
    maintainers = [stdenv.lib.maintainers.raskin];
    description = "Wacom digitizer driver for X11";
    homepage = http://linuxwacom.sf.net;
  };
}
