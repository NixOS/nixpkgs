{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "snapraid-${version}";
  version = "11.0";

  src = fetchurl {
    url = "https://github.com/amadvance/snapraid/releases/download/v${version}/snapraid-${version}.tar.gz";
    sha256 = "0wapbi8ph7qcyh1jwyrn2r5slzsznlxvg137r4l02xgaaf42p9rh";
  };

  doCheck = true;

  meta = {
    homepage = http://www.snapraid.it/;
    description = "A backup program for disk arrays";
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.makefu ];
    platforms = stdenv.lib.platforms.unix;
  };
}
