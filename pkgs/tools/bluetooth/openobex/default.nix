{ stdenv, fetchurl, pkgconfig, bluez, libusb, cmake }:
   
stdenv.mkDerivation rec {
  name = "openobex-1.7.2";
   
  src = fetchurl {
    url = "mirror://sourceforge/openobex/${name}-Source.tar.gz";
    sha256 = "1z6l7pbwgs5pjx3861cyd3r6vq5av984bdp4r3hgrw2jxam6120m";
  };

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ bluez libusb ];

  configureFlags = [ "--enable-apps" ];

  patchPhase = ''
    sed -i "s!/lib/udev!$out/lib/udev!" udev/CMakeLists.txt
    sed -i "/if ( PKGCONFIG_UDEV_FOUND )/,/endif ( PKGCONFIG_UDEV_FOUND )/d" udev/CMakeLists.txt
    '';

  meta = with stdenv.lib; {
    homepage = http://dev.zuckschwerdt.org/openobex/;
    description = "An open source implementation of the Object Exchange (OBEX) protocol";
    platforms = platforms.linux;
    license = licenses.lgpl2Plus;
  };
}
