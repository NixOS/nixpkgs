{stdenv, fetchurl, perl}:

stdenv.mkDerivation {
  name = "ccrypt-1.9";

  src = fetchurl {
    url = mirror://sourceforge/ccrypt/ccrypt-1.9.tar.gz;
    sha256 = "1bzbfq19jnnlp221kilzxpy0l6w3hk9b1iqjz4haypzlyxswnf35";
  };

  nativeBuildInputs = [ perl ];

  meta = {
    homepage = http://ccrypt.sourceforge.net/;
    description = "Utility for encrypting and decrypting files and streams with AES-256";
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all; 
  };
}
