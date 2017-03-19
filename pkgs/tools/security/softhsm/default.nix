{ stdenv, fetchurl, botan }:

stdenv.mkDerivation rec {

  name = "softhsm-${version}";
  version = "2.2.0";

  src = fetchurl {
    url = "https://dist.opendnssec.org/source/${name}.tar.gz";
    sha256 = "1xw53zkv5xb9pxa8q84kh505yd6pkavxd12x2fjgqi6s12p2hsgb";
  };

  configureFlags = [
    "--with-crypto-backend=botan"
    "--with-botan=${botan}"
    "--sysconfdir=$out/etc"
    "--localstatedir=$out/var"
    ];

  buildInputs = [ botan ];

  postInstall = "rm -rf $out/var";

  meta = with stdenv.lib; {
    homepage = https://www.opendnssec.org/softhsm;
    description = "Cryptographic store accessible through a PKCS #11 interface";
    license = licenses.bsd2;
    maintainers = [ maintainers.leenaars ];
    platforms = platforms.linux;
  };
}
