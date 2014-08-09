{stdenv, fetchurl, libjpeg, lcms2, gettext, jasper }:

stdenv.mkDerivation rec {
  name = "dcraw-9.22";

  src = fetchurl {
    url = "http://www.cybercom.net/~dcoffin/dcraw/archive/${name}.tar.gz";
    sha256 = "00dz85fr5r9k3nlwdbdi30fpqr8wihamzpyair7l7zk0vkrax402";
  };

  buildInputs = [ libjpeg lcms2 gettext jasper ];

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
    platforms = with stdenv.lib.platforms; allBut cygwin;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
