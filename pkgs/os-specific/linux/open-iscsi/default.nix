{ stdenv, fetchurl, kernel}:
let
  pname = "open-iscsi-2.0-871";
in stdenv.mkDerivation {
  name = "${pname}-${kernel.version}";
  
  src = fetchurl {
    url = "http://www.open-iscsi.org/bits/${pname}.tar.gz";
    sha256 = "1jvx1agybaj4czhz41bz37as076spicsmlh5pjksvwl2mr38gsmw";
  };
  
  KSRC = "${kernel.dev}/lib/modules/*/build";
  DESTDIR = "$(out)";
  
  preConfigure = ''
    sed -i 's|/usr/|/|' Makefile
  '';
  
  patches = [./kernel.patch];
  
  meta = {
    description = "A high performance, transport independent, multi-platform implementation of RFC3720";
    license = stdenv.lib.licenses.gpl2Plus;
    homepage = http://www.open-iscsi.org;
    broken = true;
  };
}
