{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "aespipe-${version}";
  version = "2.4d";

  src = fetchurl {
    url = "mirror://sourceforge/loop-aes/aespipe/aespipe-v${version}.tar.bz2";
    sha256 = "03z5i41xv6p3m79lm04d7msda8878lsppv3324zbjjfy19p6bkn5";
  };

  meta = {
    description = "AES encrypting or decrypting pipe";
    homepage = http://loop-aes.sourceforge.net/aespipe.README;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.goibhniu ];
    platforms = stdenv.lib.platforms.linux;
  };
}
