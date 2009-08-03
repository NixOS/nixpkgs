{stdenv, fetchurl, libX11, libXi, 
  inputproto, xproto, ncurses, pkgconfig,
  xorgserver,
  udevSupport ? false}:

stdenv.mkDerivation {
  name = "linuxwacom-0.8.4";
  
  src = fetchurl {
    url = "http://prdownloads.sourceforge.net/linuxwacom/linuxwacom-0.8.4.tar.bz2";
    sha256 = "1g1myn9wmczavkkb9jjfqq87la3n94nnwjm7w7yyyxsrdw4bavp5";
  };
  
  buildInputs = [libX11 libXi inputproto 
    xproto ncurses pkgconfig xorgserver];
  
  preConfigure = ''
    ./configure --enable-wacomdrv --prefix=$out \
      --with-xlib --with-xorg-sdk --enable-wacdump --enable-xsetwacom \
      --with-xmoduledir=$out/lib/xorg/modules/input
    mv configure configure.removed
  '';

  postInstall = ''
    if test -n "${toString udevSupport}"; then
      ensureDir $out/etc/udev/rules.d
      cp ${./10-wacom.rules} $out/etc/udev/rules.d/10-wacom.rules
    fi
  '';

  meta = {
    maintainers = [stdenv.lib.maintainers.raskin];
    description = "Wacom digitizer driver for X11";
    homepage = http://linuxwacom.sf.net;
  };
}
