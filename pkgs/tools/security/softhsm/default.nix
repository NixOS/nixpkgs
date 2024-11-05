{ lib, stdenv, fetchurl, botan2, sqlite, libobjc, Security }:

stdenv.mkDerivation rec {

  pname = "softhsm";
  version = "2.6.1";

  src = fetchurl {
    url = "https://dist.opendnssec.org/source/${pname}-${version}.tar.gz";
    hash = "sha256-YSSUcwVLzRgRUZ75qYmogKe9zDbTF8nCVFf8YU30dfI=";
  };

  configureFlags = [
    "--with-crypto-backend=botan"
    "--with-botan=${lib.getDev botan2}"
    "--with-objectstore-backend-db"
    "--sysconfdir=$out/etc"
    "--localstatedir=$out/var"
  ];

  propagatedBuildInputs =
    lib.optionals stdenv.hostPlatform.isDarwin [ libobjc Security ];

  buildInputs = [ botan2 sqlite ];

  postInstall = "rm -rf $out/var";

  meta = with lib; {
    homepage = "https://www.opendnssec.org/softhsm";
    description = "Cryptographic store accessible through a PKCS #11 interface";
    longDescription = "
      SoftHSM provides a software implementation of a generic
      cryptographic device with a PKCS#11 interface, which is of
      course especially useful in environments where a dedicated hardware
      implementation of such a device - for instance a Hardware
      Security Module (HSM) or smartcard - is not available.

      SoftHSM follows the OASIS PKCS#11 standard, meaning it should be
      able to work with many cryptographic products. SoftHSM is a
      programme of The Commons Conservancy.
    ";
    license = licenses.bsd2;
    maintainers = [ maintainers.leenaars ];
    platforms = platforms.unix;
  };
}
