{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "snapraid-${version}";
  version = "10.0";

  src = fetchurl {
    url = "https://github.com/amadvance/snapraid/releases/download/v${version}/snapraid-${version}.tar.gz";
    sha256 = "1mhs0gl285a5y2bw6k04lrnyg1pp2am7dfcsvg0w4vr5h2ag3p7p";
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
