{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  pname = "scrypt";
  version = "1.3.0";

  src = fetchurl {
    url = "https://www.tarsnap.com/scrypt/${pname}-${version}.tgz";
    sha256 = "0j17yfrpi2bk5cawb4a4mzpv1vadqxh956hx0pa1gqfisknk8c16";
  };

  buildInputs = [ openssl ];

  patchPhase = ''
    for f in Makefile.in autotools/Makefile.am libcperciva/cpusupport/Build/cpusupport.sh ; do
      substituteInPlace $f --replace "command -p " ""
    done
  '';

  meta = with stdenv.lib; {
    description = "Encryption utility";
    homepage    = "https://www.tarsnap.com/scrypt.html";
    license     = licenses.bsd2;
    platforms   = platforms.all;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
