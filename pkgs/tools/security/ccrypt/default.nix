{
  lib,
  stdenv,
  fetchurl,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "ccrypt";
  version = "1.11";

  src = fetchurl {
    url = "mirror://sourceforge/ccrypt/ccrypt-${version}.tar.gz";
    sha256 = "0kx4a5mhmp73ljknl2lcccmw9z3f5y8lqw0ghaymzvln1984g75i";
  };

  nativeBuildInputs = [ perl ];

  hardeningDisable = [ "format" ];

  meta = {
    homepage = "https://ccrypt.sourceforge.net/";
    description = "Utility for encrypting and decrypting files and streams with AES-256";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ viric ];
    platforms = with lib.platforms; all;
  };
}
