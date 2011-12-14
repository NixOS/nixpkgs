{stdenv, fetchurl, libuuid, popt, devicemapper, udev }:

stdenv.mkDerivation {
  name = "cryptsetup-1.0.6";
  src = fetchurl {
    url = http://cryptsetup.googlecode.com/files/cryptsetup-1.0.6.tar.bz2;
    sha256 = "df7fda80cfa01f063caf39140287a47d018dfe056fc71a3ba605e690ff0183fd";
  };

  configureFlags = [ "--enable-libdevmapper" ];

  patchPhase = ''
    sed -i -e 's@/sbin/udevsettle@${udev}/sbin/udevadm settle@' lib/libdevmapper.c
  '';

  buildInputs = [ libuuid popt devicemapper ];

  meta = {
    homepage = http://code.google.com/p/cryptsetup/;
    description = "LUKS for dm-crypt";
    license = "GPLv2";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
