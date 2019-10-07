{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "aespipe";
  version = "2.4f";

  src = fetchurl {
    url = "mirror://sourceforge/loop-aes/aespipe/aespipe-v${version}.tar.bz2";
    sha256 = "15pg9j27mjzl78mpzkdqd84kdafj0g6j72f8wgjrpp2qkxjy2ddi";
  };

  meta = {
    description = "AES encrypting or decrypting pipe";
    homepage = http://loop-aes.sourceforge.net/aespipe.README;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.goibhniu ];
    platforms = stdenv.lib.platforms.linux;
  };
}
