{ stdenv, fetchurl, pam }:
   
stdenv.mkDerivation rec {
  name = "shadow-4.1.4.2";
   
  src = fetchurl {
    url = "ftp://pkg-shadow.alioth.debian.org/pub/pkg-shadow/${name}.tar.bz2";
    sha256 = "1449ny7pdnwkavg92wvibapnkgdq5pas38nvl1m5xa37g5m7z64p";
  };

  buildInputs = [ pam ];
  
  meta = {
    homepage = http://pkg-shadow.alioth.debian.org/;
    description = "Suite containing authentication-related tools such as passwd and su";
  };
}
