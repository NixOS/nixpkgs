{ stdenv, fetchFromGitHub, pkgconfig, vpnc, openssl ? null, gnutls ? null, gmp, libxml2, stoken, zlib, autoreconfHook } :

assert (openssl != null) == (gnutls == null);

stdenv.mkDerivation rec {
  version = "unstable-2018-10-08";
  name = "openconnect_pa-${version}";
  
  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "dlenski";
    repo = "openconnect";
    rev = "e5fe063a087385c5b157ad7a9a3fa874181f6e3b";
    sha256 = "0ywacqs3nncr2gpjjcz2yc9c6v4ifjssh0vb07h0qff06whqhdax"; 
  };

  preConfigure = ''
      export PKG_CONFIG=${pkgconfig}/bin/pkg-config
      export LIBXML2_CFLAGS="-I ${libxml2.dev}/include/libxml2"
      export LIBXML2_LIBS="-L${libxml2.out}/lib -lxml2"
  '';

  configureFlags = [
    "--with-vpnc-script=${vpnc}/etc/vpnc/vpnc-script"
    "--disable-nls"
    "--without-openssl-version-check"
  ];

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  propagatedBuildInputs = [ vpnc openssl gnutls gmp libxml2 stoken zlib ];
  
  meta = with stdenv.lib; {
    description = "OpenConnect client extended to support Palo Alto Networks' GlobalProtect VPN";
    homepage = https://github.com/dlenski/openconnect/;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ chessai ];
    platforms = platforms.linux;
  };
}
