{stdenv, fetchurl, perl}:

stdenv.mkDerivation {
  name = "ccrypt-1.10";

  src = fetchurl {
    url = mirror://sourceforge/ccrypt/ccrypt-1.10.tar.gz;
    sha256 = "184v9676hx2w875cz04rd3a20wrcms33a1zwybvapb0g2yi6vml7";
  };

  nativeBuildInputs = [ perl ];

  hardeningDisable = [ "format" ];

  meta = {
    homepage = http://ccrypt.sourceforge.net/;
    description = "Utility for encrypting and decrypting files and streams with AES-256";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all; 
  };
}
