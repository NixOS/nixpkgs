{ stdenv, fetchurl }:
   
stdenv.mkDerivation rec {
  name = "cifs-utils-5.3";
   
  src = fetchurl {
    url = "ftp://ftp.samba.org/pub/linux-cifs/cifs-utils/${name}.tar.bz2";
    sha256 = "68e969c4107a872e2848992732dc11eafc7bdf084bec894c0ba677572de49b32";
  };

  makeFlags = "root_sbindir=$(out)/sbin";

  meta = {
    homepage = http://www.samba.org/linux-cifs/cifs-utils/;
    description = "Tools for managing Linux CIFS client filesystems";
    platforms = stdenv.lib.platforms.linux;    
  };
}
