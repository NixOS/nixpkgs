{stdenv, fetchurl, devicemapper, libgcrypt, libuuid, pkgconfig, popt, udev }:

stdenv.mkDerivation rec {
  name = "cryptsetup-1.4.1";
  src = fetchurl {
    url = "http://cryptsetup.googlecode.com/files/${name}.tar.bz2";
    sha256 = "82b143328c2b427ef2b89fb76c701d311c95b54093c21bbf22342f7b393bddcb";
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
