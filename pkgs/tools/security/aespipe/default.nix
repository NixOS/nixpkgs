{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "aespipe";
  version = "2.4e";

  src = fetchurl {
    url = "mirror://sourceforge/loop-aes/aespipe/aespipe-v${version}.tar.bz2";
    sha256 = "0fmr0vk408bf13jydhdmcdhqw31yc9qk329bs9i60alccywapmds";
  };

  meta = {
    description = "AES encrypting or decrypting pipe";
    homepage = http://loop-aes.sourceforge.net/aespipe.README;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.goibhniu ];
    platforms = stdenv.lib.platforms.linux;
  };
}
