{ lib, stdenv, fetchurl, openssl, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "pure-ftpd";
  version = "1.0.49";

  src = fetchurl {
    url = "https://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-${version}.tar.gz";
    sha256 = "19cjr262n6h560fi9nm7l1srwf93k34bp8dp1c6gh90bqxcg8yvn";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2020-9274.patch";
      url = "https://github.com/jedisct1/pure-ftpd/commit/8d0d42542e2cb7a56d645fbe4d0ef436e38bcefa.patch";
      sha256 = "1yd84p6bd4rf21hg3kqpi2a02cac6dz5ag4xx3c2dl5vbzhr5a8k";
    })
    (fetchpatch {
      name = "CVE-2020-9365.patch";
      url = "https://github.com/jedisct1/pure-ftpd/commit/bf6fcd4935e95128cf22af5924cdc8fe5c0579da.patch";
      sha256 = "003klx7j82qf92qr1dxg32v5r2bhhywplynd3xil1lbcd3s3mqhi";
    })
  ];

  buildInputs = [ openssl ];

  configureFlags = [ "--with-tls" ];

  meta = with lib; {
    description = "A free, secure, production-quality and standard-conformant FTP server";
    homepage = "https://www.pureftpd.org";
    license = licenses.isc; # with some parts covered by BSD3(?)
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
