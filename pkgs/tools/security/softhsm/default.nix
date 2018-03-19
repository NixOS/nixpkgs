{ stdenv, fetchurl, botan, libobjc, Security }:

stdenv.mkDerivation rec {

  name = "softhsm-${version}";
  version = "2.4.0";

  src = fetchurl {
    url = "https://dist.opendnssec.org/source/${name}.tar.gz";
    sha256 = "01ysfmq0pzr3g9laq40xwq8vg8w135d4m8n05mr1bkdavqmw3ai6";
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
