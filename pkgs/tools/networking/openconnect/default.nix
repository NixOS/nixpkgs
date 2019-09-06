{ stdenv, fetchurl, pkgconfig, vpnc, openssl ? null, gnutls ? null, gmp, libxml2, stoken, zlib } :

assert (openssl != null) == (gnutls == null);

stdenv.mkDerivation rec {
  pname = "openconnect";
  version = "8.04";

  src = fetchurl {
    urls = [
      "ftp://ftp.infradead.org/pub/openconnect/${pname}-${version}.tar.gz"
    ];
    sha256 = "07zqcl2ykdc4mgix9sbv4jgpg7cybifxfgrycvf99ckq7xp9r5wq";
  };

  outputs = [ "out" "dev" ];

  configureFlags = [
    "--with-vpnc-script=${vpnc}/etc/vpnc/vpnc-script"
    "--disable-nls"
    "--without-openssl-version-check"
  ];

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ vpnc openssl gnutls gmp libxml2 stoken zlib ];

  meta = {
    description = "VPN Client for Cisco's AnyConnect SSL VPN";
    homepage = http://www.infradead.org/openconnect/;
    license = stdenv.lib.licenses.lgpl21;
    maintainers = with stdenv.lib.maintainers; [ pradeepchhetri ];
    platforms = stdenv.lib.platforms.linux;
  };
}
