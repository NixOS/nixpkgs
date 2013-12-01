{stdenv, fetchurl, libjpeg, lcms, gettext, jasper }:

stdenv.mkDerivation rec {
  name = "dcraw-9.19";

  src = fetchurl {
    url = "http://www.cybercom.net/~dcoffin/dcraw/archive/${name}.tar.gz";
    sha256 = "0x2qjavfp97vadw29d384sb887wgpfki4sl00p5lximf0a7fa0dv";
  };

  buildInputs = [ libjpeg lcms gettext jasper ];

  patchPhase = ''
    sed -i -e s@/usr/local@$out@ install
  '';

  buildPhase = ''
    mkdir -p $out/bin
    sh install
  '';

  meta = {
    homepage = http://www.cybercom.net/~dcoffin/dcraw/;
    description = "Decoder for many camera raw picture formats";
    license = "free";
    platforms = stdenv.lib.platforms.allBut "i686-cygwin";
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
