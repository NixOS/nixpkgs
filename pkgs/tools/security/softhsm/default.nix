{ stdenv, fetchurl, botan }:

stdenv.mkDerivation rec {

  name = "softhsm-${version}";
  version = "2.3.0";

  src = fetchurl {
    url = "https://dist.opendnssec.org/source/${name}.tar.gz";
    sha256 = "09y1ladg7j0j5n780b1hdzwd2g2b5j5c54pfs7bzjviskb409mjy";
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
