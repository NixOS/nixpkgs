{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  name = "scrypt-${version}";
  version = "1.2.0";

  src = fetchurl {
    url = "https://www.tarsnap.com/scrypt/${name}.tgz";
    sha256 = "1m39hpfby0fdjam842773i5w7pa0qaj7f0r22jnchxsj824vqm0p";
  };

  buildInputs = [ openssl ];

  patchPhase = ''
    substituteInPlace Makefile.in \
      --replace "command -p mv" "mv"
    substituteInPlace autocrap/Makefile.am \
      --replace "command -p mv" "mv"
  '';

  meta = {
    description = "Encryption utility";
    homepage    = https://www.tarsnap.com/scrypt.html;
    license     = stdenv.lib.licenses.bsd2;
    platforms   = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
