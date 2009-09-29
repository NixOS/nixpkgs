{ stdenv, fetchurl, libX11, libXi, inputproto
, xproto, ncurses, pkgconfig, xorgserver }:

let s = import ./src-for-default.nix; in

stdenv.mkDerivation rec {
  inherit (s) name;
  
  src = fetchurl {
    url = s.url;
    sha256 = s.hash;
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
