{ stdenv, fetchurl, unzip, botan }:

stdenv.mkDerivation rec {

  name = "softhsm-${version}";
  majorVersion = "2";
  version = "${majorVersion}.1.0";

  src = fetchurl {
    url = "https://dist.opendnssec.org/source/${name}.tar.gz";
    sha256 = "0399b06f196fbfaebe73b4aeff2e2d65d0dc1901161513d0d6a94f031dcd827e";
  };

  configureFlags = [
    "--with-crypto-backend=botan"
    "--with-botan=${botan}"
    "--sysconfdir=$out/etc"
    "--localstatedir=$out/var"
    ];

  buildInputs = [ botan];

  postInstall = "rm -rf $out/var";

  meta = {
    homepage = https://www.opendnssec.org/softhsm;
    description = "Cryptographic store accessible through a PKCS #11 interface";
    license = stdenv.lib.licenses.bsd2;
    maintainers = stdenv.lib.maintainers.leenaars;
    platforms = stdenv.lib.platforms.linux;
  };
}
