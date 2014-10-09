{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "cifs-utils-6.4";

  src = fetchurl {
    url = "ftp://ftp.samba.org/pub/linux-cifs/cifs-utils/${name}.tar.bz2";
    sha256 = "1qz6d2xg4z1if0hy7qwyzgcr59l0alkhci6gxgjdldglda967z1q";
  };

  makeFlags = "root_sbindir=$(out)/sbin";

  meta = {
    homepage = http://www.samba.org/linux-cifs/cifs-utils/;
    description = "Tools for managing Linux CIFS client filesystems";
    platforms = stdenv.lib.platforms.linux;
  };
}
