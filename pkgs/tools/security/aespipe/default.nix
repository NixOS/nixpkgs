{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "aespipe-${version}";
  version = "2.4c";

  src = fetchurl {
    url = "mirror://sourceforge/loop-aes/aespipe/aespipe-v${version}.tar.bz2";
    sha256 = "0pl49jnjczjvfxwm9lw576qsjm1lxh8gc4g776l904cixaz90096";
  };

  meta = {
    description = "AES encrypting or decrypting pipe";
    homepage = http://loop-aes.sourceforge.net/aespipe.README;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.goibhniu ];
    platforms = stdenv.lib.platforms.linux;
  };
}
