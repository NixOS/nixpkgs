{ stdenv, fetchurl
, file, inputproto, libX11, libXext, libXi, libXrandr, libXrender
, ncurses, pkgconfig, randrproto, xorgserver, xproto, udev, libXinerama, pixman }:

stdenv.mkDerivation rec {
  name = "xf86-input-wacom-0.36.0";

  src = fetchurl {
    url = "mirror://sourceforge/linuxwacom/${name}.tar.bz2";
    sha256 = "1xi39hl8ddgj9m7m2k2ll2r3wh0k0aq45fvrsv43651bhz9cbrza";
  };

  buildInputs = [ inputproto libX11 libXext libXi libXrandr libXrender
    ncurses pkgconfig randrproto xorgserver xproto udev libXinerama pixman ];

  preConfigure = ''
    mkdir -p $out/share/X11/xorg.conf.d
    configureFlags="--with-xorg-module-dir=$out/lib/xorg/modules
    --with-sdkdir=$out/include/xorg --with-xorg-conf-dir=$out/share/X11/xorg.conf.d"
  '';

  CFLAGS = "-I${pixman}/include/pixman-1";

  meta = with stdenv.lib; {
    maintainers = [ maintainers.goibhniu ];
    description = "Wacom digitizer driver for X11";
    homepage = http://linuxwacom.sourceforge.net;
    license = licenses.gpl2;
    platforms = platforms.linux; # Probably, works with other unices as well
  };
}
