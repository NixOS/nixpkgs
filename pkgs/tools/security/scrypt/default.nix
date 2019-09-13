{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  pname = "scrypt";
  version = "1.2.1";

  src = fetchurl {
    url = "https://www.tarsnap.com/scrypt/${pname}-${version}.tgz";
    sha256 = "0xy5yhrwwv13skv9im9vm76rybh9f29j2dh4hlh2x01gvbkza8a6";
  };

  buildInputs = [ openssl ];

  patchPhase = ''
    for f in Makefile.in autotools/Makefile.am libcperciva/cpusupport/Build/cpusupport.sh ; do
      substituteInPlace $f --replace "command -p " ""
    done
  '';

  meta = with stdenv.lib; {
    description = "Encryption utility";
    homepage    = https://www.tarsnap.com/scrypt.html;
    license     = licenses.bsd2;
    platforms   = platforms.all;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
