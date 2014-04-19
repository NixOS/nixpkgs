{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "cifs-utils-6.3";

  src = fetchurl {
    url = "ftp://ftp.samba.org/pub/linux-cifs/cifs-utils/${name}.tar.bz2";
    sha256 = "0nrpd3ibzfhdxgq1pw0jhzx163z5jvq4qcjxl35qlqj74lm3pxzz";
  };

  makeFlags = "root_sbindir=$(out)/sbin";

  meta = {
    homepage = http://www.samba.org/linux-cifs/cifs-utils/;
    description = "Tools for managing Linux CIFS client filesystems";
    platforms = stdenv.lib.platforms.linux;
  };
}
