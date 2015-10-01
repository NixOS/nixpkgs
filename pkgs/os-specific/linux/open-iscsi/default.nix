{ stdenv, fetchurl }:
let
  pname = "open-iscsi-2.0-873";
in stdenv.mkDerivation {
  name = "${pname}";
  
  src = fetchurl {
    url = "http://www.open-iscsi.org/bits/${pname}.tar.gz";
    sha256 = "1nbwmj48xzy45h52917jbvyqpsfg9zm49nm8941mc5x4gpwz5nbx";
  };
  
  DESTDIR = "$(out)";
  
  preConfigure = ''
    sed -i 's|/usr/|/|' Makefile
  '';
  
  meta = {
    description = "A high performance, transport independent, multi-platform implementation of RFC3720";
    license = stdenv.lib.licenses.gpl2Plus;
    homepage = http://www.open-iscsi.org;
  };
}
