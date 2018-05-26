{stdenv, fetchurl, libjpeg, lcms2, gettext, jasper }:

stdenv.mkDerivation rec {
  name = "dcraw-9.27.0";

  src = fetchurl {
    url = "http://www.cybercom.net/~dcoffin/dcraw/archive/${name}.tar.gz";
    sha256 = "16bhk3pl5kb9ikv367szl8m92nx85rqypz5im8x3sakm357wrn61";
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
    license = stdenv.lib.licenses.free;
    platforms = stdenv.lib.platforms.unix; # Once had cygwin problems
    maintainers = [ ];
  };
}
