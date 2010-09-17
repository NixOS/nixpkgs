{ stdenv, fetchurl }:
   
stdenv.mkDerivation rec {
  name = "cifs-utils-4.5";
   
  src = fetchurl {
    url = "ftp://ftp.samba.org/pub/linux-cifs/cifs-utils/${name}.tar.bz2";
    sha256 = "0nzjxhhs86ws1dzi2qgmxbkn6pcri7915r0sd51317b0b5n9k1w2";
  };

  makeFlags = "root_sbindir=$(out)/sbin";

  meta = {
    homepage = http://www.samba.org/linux-cifs/cifs-utils/;
    description = "Tools for managing Linux CIFS client filesystems";
    platforms = stdenv.lib.platforms.linux;    
  };
}
