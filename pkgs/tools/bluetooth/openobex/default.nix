{stdenv, fetchurl, pkgconfig, bluez, libusb}:
   
stdenv.mkDerivation rec {
  name = "openobex-1.5";
   
  src = fetchurl {
    url = "mirror://kernel/linux/bluetooth/${name}.tar.gz";
    sha256 = "0rayjci99ahhvs2d16as1qql3vrcizd0nhi8n3n4g6krf1sh80p6";
  };

  buildInputs = [pkgconfig bluez libusb];

  configureFlags = "--enable-apps";

  meta = {
    homepage = http://dev.zuckschwerdt.org/openobex/;
    description = "An open source implementation of the Object Exchange (OBEX) protocol";
    platforms = stdenv.lib.platforms.linux;
  };
}
