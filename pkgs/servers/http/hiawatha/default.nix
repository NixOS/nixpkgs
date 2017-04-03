{ stdenv, fetchurl, cmake,
  libxslt, zlib, libxml2, openssl,
  enableSSL ? true,
  enableMonitor ? false,
  enableRproxy ? true,
  enableTomahawk ? false,
  enableXSLT ? true,
  enableToolkit ? true
}:

assert enableSSL -> openssl !=null;

stdenv.mkDerivation rec {
  name = "hiawatha-${version}";
  version = "10.5";

  src = fetchurl {
    url = "https://github.com/hsleisink/hiawatha/archive/v${version}.tar.gz";
    sha256 = "11nqdmmhq1glgsiza8pfh69wmpgwl51vb3xijmpcxv63a7ywp4fj";
  };

  buildInputs =  [ cmake libxslt zlib libxml2 ] ++ stdenv.lib.optional enableSSL openssl ;

  cmakeFlags = [
    ( if enableSSL then "-DENABLE_TLS=on" else "-DENABLE_TLS=off" )
    ( if enableMonitor then "-DENABLE_MONITOR=on" else "-DENABLE_MONITOR=off" )
    ( if enableRproxy then "-DENABLE_RPROXY=on" else "-DENABLE_RPROXY=off" )
    ( if enableTomahawk then "-DENABLE_TOMAHAWK=on" else "-DENABLE_TOMAHAWK=off" )
    ( if enableXSLT then "-DENABLE_XSLT=on" else "-DENABLE_XSLT=off" )
    ( if enableToolkit then "-DENABLE_TOOLKIT=on" else "-DENABLE_TOOLKIT=off" )
    "-DWEBROOT_DIR=/var/www/hiawatha"
    "-DPID_DIR=/run"
    "-DWORK_DIR=/var/lib/hiawatha"
    "-DLOG_DIR=/var/log/hiawatha"
  ];

  # workaround because cmake tries installs stuff outside of nix store
  makeFlags = [ "DESTDIR=$(out)" "PREFIX=" ];
  postInstall = ''
    mv $out/$out/* $out
    rm -rf $out/{var,run}
  '';

  meta = with stdenv.lib; {
    description = "An advanced and secure webserver";
    license = licenses.gpl2;
    homepage = "https://www.hiawatha-webserver.org";
    maintainer = [ maintainers.ndowens ];
  };

}
