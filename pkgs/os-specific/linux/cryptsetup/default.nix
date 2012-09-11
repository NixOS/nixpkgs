{ stdenv, fetchurl, devicemapper, libgcrypt, libuuid, pkgconfig, popt }:

stdenv.mkDerivation rec {
  name = "cryptsetup-1.5.0";

  src = fetchurl {
    url = "http://cryptsetup.googlecode.com/files/${name}.tar.bz2";
    sha256 = "1l7qcmaq092k28k8sbw845hs6jwn0f05h68rmb7iwh52232m8wa0";
  };

  configureFlags = "--enable-cryptsetup-reencrypt";

  buildInputs = [ devicemapper libgcrypt libuuid pkgconfig popt ];

  meta = {
    homepage = http://code.google.com/p/cryptsetup/;
    description = "LUKS for dm-crypt";
    license = "GPLv2";
    maintainers = with stdenv.lib.maintainers; [ viric chaoflow ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
