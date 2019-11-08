{ stdenv, fetchurl, pkgconfig, openssl ? null, gnutls ? null, gmp, libxml2, stoken, zlib, fetchgit, darwin } :

assert (openssl != null) == (gnutls == null);

let vpnc = fetchgit {
  url = "git://git.infradead.org/users/dwmw2/vpnc-scripts.git";
  rev = "c84fb8e5a523a647a01a1229a9104db934e19f00";
  sha256 = "01xdclx0y3x66mpbdr77n4ilapwzjz475h32q88ml9gnq6phjxrs";
};

in stdenv.mkDerivation rec {
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
    "--with-vpnc-script=${vpnc}/vpnc-script"
    "--disable-nls"
    "--without-openssl-version-check"
  ];

  buildInputs = [ openssl gnutls gmp libxml2 stoken zlib ]
    ++ stdenv.lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.PCSC;
  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    description = "VPN Client for Cisco's AnyConnect SSL VPN";
    homepage = http://www.infradead.org/openconnect/;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ pradeepchhetri tricktron ];
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };
}
