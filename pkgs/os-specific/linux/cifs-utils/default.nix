{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "cifs-utils-6.2";

  src = fetchurl {
    url = "ftp://ftp.samba.org/pub/linux-cifs/cifs-utils/${name}.tar.bz2";
    sha256 = "0cydya7l7xwxk2j1g1659kbvb4jzql11ivb6cldwwfg19qvnwrrl";
  };

  makeFlags = "root_sbindir=$(out)/sbin";

  meta = {
    homepage = http://www.samba.org/linux-cifs/cifs-utils/;
    description = "Tools for managing Linux CIFS client filesystems";
    platforms = stdenv.lib.platforms.linux;
  };
}
