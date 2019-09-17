{ stdenv, fetchurl, pkgconfig, vpnc, openssl ? null, gnutls ? null, gmp, libxml2, stoken, zlib } :

assert (openssl != null) == (gnutls == null);

stdenv.mkDerivation rec {
  pname = "openconnect";
  version = "8.05";

  src = fetchurl {
    urls = [
      "ftp://ftp.infradead.org/pub/openconnect/${pname}-${version}.tar.gz"
    ];
    sha256 = "14i9q727c2zc9xhzp1a9hz3gzb5lwgsslbhircm84dnbs192jp1k";
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
