{stdenv, fetchurl, pkgconfig, bluez, libusb, cmake}:
   
stdenv.mkDerivation rec {
  name = "openobex-1.7.1";
   
  src = fetchurl {
    url = "mirror://sourceforge/openobex/${name}-Source.tar.gz";
    sha256 = "0mza0mrdrbcw4yix6qvl31kqy7bdkgxjycr0yx7yl089v5jlc9iv";
  };

  buildInputs = [pkgconfig bluez libusb cmake];

  configureFlags = "--enable-apps";

  patchPhase = ''
    sed -i "s!/lib/udev!$out/lib/udev!" udev/CMakeLists.txt
    sed -i "/if ( PKGCONFIG_UDEV_FOUND )/,/endif ( PKGCONFIG_UDEV_FOUND )/d" udev/CMakeLists.txt
    '';

  meta = {
    homepage = http://dev.zuckschwerdt.org/openobex/;
    description = "An open source implementation of the Object Exchange (OBEX) protocol";
    platforms = stdenv.lib.platforms.linux;
  };
}
