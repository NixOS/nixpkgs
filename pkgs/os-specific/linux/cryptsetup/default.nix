{ stdenv, fetchurl, devicemapper, libgcrypt, libuuid, pkgconfig, popt }:

stdenv.mkDerivation rec {
  name = "cryptsetup-1.5.1";

  src = fetchurl {
    url = "http://cryptsetup.googlecode.com/files/${name}.tar.bz2";
    sha256 = "0dib3nw6ifd7d7hr9k4iyaha3hz0pkzairqa38l3fndkr9w3zlhn";
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
