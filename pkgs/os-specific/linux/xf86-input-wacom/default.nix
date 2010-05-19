{ stdenv, fetchurl, libX11, libXi, inputproto, file
, xproto, ncurses, pkgconfig, xorgserver }:

stdenv.mkDerivation rec {
  name = "xf86-input-wacom-0.10.5";

  src = fetchurl {
    url = "mirror://sourceforge/linuxwacom/${name}.tar.bz2";
    sha256 = "07rg9a9n1dyjff4awlc5imy44y0lg59qs8h4rr56lgjg612wkmy0";
  };

  buildInputs = [ libX11 libXi inputproto xproto ncurses pkgconfig xorgserver
    file ];

  patchPhase="sed -e s@/usr/bin/file@${file}/bin/file@g -i configure";

  preConfigure = ''
    configureFlags="--with-xorg-module-dir=$out/lib/xorg/modules/input
    --with-sdkdir=$out/include/xorg"
  '';

  postInstall =
    ''
      ensureDir $out/etc/udev/rules.d
      cp ${./10-wacom.rules} $out/etc/udev/rules.d/10-wacom.rules
    '';

  meta = with stdenv.lib; {
    maintainers = [ maintainers.urkud ];
    description = "Wacom digitizer driver for X11";
    homepage = http://linuxwacom.sourceforge.net;
    platforms = platforms.linux; # Probably, works with other unices as well
  };
}
