{ stdenv, fetchurl, devicemapper, libgcrypt, libuuid, pkgconfig, popt, udev }:

stdenv.mkDerivation rec {
  name = "cryptsetup-1.4.2";
  
  src = fetchurl {
    url = "http://cryptsetup.googlecode.com/files/${name}.tar.bz2";
    sha256 = "1ryzc36wfbfqi69c3xzx2x6jr7l5xp7xwip4s9jkyjyj35xhvs0z";
  };

  buildInputs = [ devicemapper libgcrypt libuuid pkgconfig popt ];

  meta = {
    homepage = http://code.google.com/p/cryptsetup/;
    description = "LUKS for dm-crypt";
    license = "GPLv2";
    maintainers = with stdenv.lib.maintainers; [ viric chaoflow ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
