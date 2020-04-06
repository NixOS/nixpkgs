{ stdenv, fetchurl, botan, libobjc, Security }:

stdenv.mkDerivation rec {

  pname = "softhsm";
  version = "2.5.0";

  src = fetchurl {
    url = "https://dist.opendnssec.org/source/${pname}-${version}.tar.gz";
    sha256 = "1cijq78jr3mzg7jj11r0krawijp99p253f4qdqr94n728p7mdalj";
  };

  configureFlags = [
    "--with-crypto-backend=botan"
    "--with-botan=${botan}"
    "--sysconfdir=$out/etc"
    "--localstatedir=$out/var"
    ];

  propagatedBuildInputs =
    stdenv.lib.optionals stdenv.isDarwin [ libobjc Security ];

  buildInputs = [ botan ];

  postInstall = "rm -rf $out/var";

  meta = with stdenv.lib; {
    homepage = https://www.opendnssec.org/softhsm;
    description = "Cryptographic store accessible through a PKCS #11 interface";
    license = licenses.bsd2;
    maintainers = [ maintainers.leenaars ];
    platforms = platforms.unix;
  };
}
