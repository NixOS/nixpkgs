{ stdenv, fetchurl, unzip, botan }:

stdenv.mkDerivation rec {

  name = "softhsm-${version}";
  majorVersion = "2";
  version = "${majorVersion}.0.0";

  src = fetchurl {
    url = "https://dist.opendnssec.org/source/${name}.tar.gz";
    sha256 = "eae8065f6c472af24f4c056d6728edda0fd34306f41a818697f765a6a662338d";
  };

  configureFlags = [
    "--with-crypto-backend=botan"
    "--with-botan=${botan}"
    "--sysconfdir=$out/etc"
    "--localstatedir=$out/var"
    ];

  buildInputs = [ botan];

  meta = {
    homepage = https://www.opendnssec.org/softhsm/;
    description = "Cryptographic store accessible through a PKCS #11 interface";
    license = stdenv.lib.licenses.bsd;
    maintainers = with stdenv.lib.maintainers; [];
    platforms = with stdenv.lib.platforms; all; 
  };
}
