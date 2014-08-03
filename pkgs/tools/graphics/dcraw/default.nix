{stdenv, fetchurl, libjpeg, lcms, gettext, jasper }:

stdenv.mkDerivation rec {
  name = "dcraw-9.22";

  src = fetchurl {
    url = "http://www.cybercom.net/~dcoffin/dcraw/archive/${name}.tar.gz";
    sha256 = "0wjs90xdzdxi51qikbvc66gb912k2ay7jn9b31wv4rxxzgnbk4cs";
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
