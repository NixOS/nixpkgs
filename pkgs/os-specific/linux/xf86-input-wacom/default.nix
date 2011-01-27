{ stdenv, fetchurl, libX11, libXi, inputproto, file
, xproto, ncurses, pkgconfig, xorgserver, 
libXext, libXrandr, randrproto, libXrender }:

stdenv.mkDerivation rec {
  name = "xf86-input-wacom-0.10.10";

  src = fetchurl {
    url = "mirror://sourceforge/linuxwacom/${name}.tar.bz2";
    sha256 = "03yggp2ww64va6gmasl0gy0rbfcyb1zlj9kapp9kvhk2j4458fdr";
  };

  buildInputs = [ libX11 libXi inputproto xproto ncurses pkgconfig xorgserver
    file libXext libXrandr libXrender randrproto ];

  preConfigure = ''
    ensureDir $out/share/X11/xorg.conf.d
    configureFlags="--with-xorg-module-dir=$out/lib/xorg/modules
    --with-sdkdir=$out/include/xorg --with-xorg-conf-dir=$out/share/X11/xorg.conf.d"
  '';

  postInstall =
    ''
      ensureDir $out/lib/udev/rules.d
      cp ${./10-wacom.rules} $out/lib/udev/rules.d/10-wacom.rules
    '';

  meta = with stdenv.lib; {
    maintainers = [ maintainers.urkud ];
    description = "Wacom digitizer driver for X11";
    homepage = http://linuxwacom.sourceforge.net;
    platforms = platforms.linux; # Probably, works with other unices as well
  };
}
