{ stdenv, autoconf, automake, pkgconfig, libtool, vpnc, openssl ? null, gnutls ? null, gmp, libxml2, stoken, zlib } :

assert (openssl != null) == (gnutls == null);

stdenv.mkDerivation rec {
  name = "openconnect-globalprotect-7.08";

  src = fetchGit {
    url = "https://github.com/dlenski/openconnect.git";
    rev = "2d2da4771acb5acad31102c343372cb1390bbec3";
    ref = "globalprotect";
  };

  outputs = [ "out" "dev" ];

  preConfigure = ''
    ./autogen.sh
  '';

  configureFlags = [
    "--with-vpnc-script=${vpnc}/etc/vpnc/vpnc-script"
    "--disable-nls"
    "--without-openssl-version-check"
  ];

  nativeBuildInputs = [ autoconf automake pkgconfig libtool ];
  propagatedBuildInputs = [ vpnc openssl gnutls gmp libxml2 stoken zlib ];

  meta = {
    description = "VPN Client for Cisco's AnyConnect SSL VPN";
    homepage = http://www.infradead.org/openconnect/;
    license = stdenv.lib.licenses.lgpl21;
    maintainers = with stdenv.lib.maintainers; [ pradeepchhetri ];
    platforms = stdenv.lib.platforms.linux;
  };
}
