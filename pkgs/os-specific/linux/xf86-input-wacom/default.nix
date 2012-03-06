{ stdenv, fetchurl
, file, inputproto, libX11, libXext, libXi, libXrandr, libXrender
, ncurses, pkgconfig, randrproto, xorgserver, xproto, udev }:

stdenv.mkDerivation rec {
  name = "xf86-input-wacom-0.11.1";

  src = fetchurl {
    url = "mirror://sourceforge/linuxwacom/${name}.tar.bz2";
    sha256 = "1jmnrkf89a3jjbpn17gyndlv9lqc0n7qwyi22hraxypq213gjclx";
  };

  buildInputs = [ inputproto libX11 libXext libXi libXrandr libXrender
    ncurses pkgconfig randrproto xorgserver xproto udev ];

  preConfigure = ''
    mkdir -p $out/share/X11/xorg.conf.d
    configureFlags="--with-xorg-module-dir=$out/lib/xorg/modules
    --with-sdkdir=$out/include/xorg --with-xorg-conf-dir=$out/share/X11/xorg.conf.d"
  '';

  meta = with stdenv.lib; {
    maintainers = [ maintainers.goibhniu maintainers.urkud ];
    description = "Wacom digitizer driver for X11";
    homepage = http://linuxwacom.sourceforge.net;
    license = licenses.gpl2;
    platforms = platforms.linux; # Probably, works with other unices as well
  };
}
