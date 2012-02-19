{ stdenv, fetchurl, kernel}:

stdenv.mkDerivation rec {
  name = "open-iscsi-2.0-871-${kernel.version}";
  
  src = fetchurl {
    url = "http://www.open-iscsi.org/bits/${name}.tar.gz";
    sha256 = "1jvx1agybaj4czhz41bz37as076spicsmlh5pjksvwl2mr38gsmw";
  };
  
  KSRC = "${kernel}/lib/modules/*/build";
  DESTDIR = "$(out)";
  
  preConfigure = ''
    sed -i 's|/usr/|/|' Makefile
  '';
  
  patches = [./kernel.patch];
  
  meta = {
    description = "A high performance, transport independent, multi-platform implementation of RFC3720";
    license = "GPLv2+";
    homepage = http://www.open-iscsi.org;
  };
}
