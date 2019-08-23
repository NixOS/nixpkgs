{stdenv, fetchurl, perl}:

stdenv.mkDerivation {
  name = "ccrypt-1.11";

  src = fetchurl {
    url = mirror://sourceforge/ccrypt/ccrypt-1.11.tar.gz;
    sha256 = "0kx4a5mhmp73ljknl2lcccmw9z3f5y8lqw0ghaymzvln1984g75i";
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
