{stdenv, fetchurl, libjpeg, lcms, gettext }:

stdenv.mkDerivation rec {
  name = "dcraw-9.04";

  src = fetchurl {
    url = "http://www.cybercom.net/~dcoffin/dcraw/archive/${name}.tar.gz";
    sha256 = "1i9w35pldyzp5xjjcy20rps7p9wkxs6vj4wz43vhfyda93nij4y0";
  };

  buildInputs = [ libjpeg lcms gettext ];

  patchPhase = ''
    sed -i -e s@/usr/local@$out@ install
  '';

  buildPhase = ''
    ensureDir $out/bin
    set +e
    sh install
    set -e
  '';

  meta = {
    homepage = http://www.cybercom.net/~dcoffin/dcraw/;
    description = "Decoder for many camera raw picture formats";
    license = "free";
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
