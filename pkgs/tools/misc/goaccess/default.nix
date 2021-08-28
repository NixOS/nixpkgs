{ lib, stdenv, fetchurl, ncurses, gettext, openssl, withGeolocation ? true, libmaxminddb }:

stdenv.mkDerivation rec {
  version = "1.4.6";
  pname = "goaccess";

  src = fetchurl {
    url = "https://tar.goaccess.io/goaccess-${version}.tar.gz";
    sha256 = "1l3j3i4vb7ni7i047qvi9a3hs43ym24r6hfcnqsbhgrb731jf3qx";
  };

  configureFlags = [
    "--enable-utf8"
    "--with-openssl"
  ] ++ lib.optionals withGeolocation [ "--enable-geoip=mmdb" ];

  buildInputs = [ ncurses openssl ]
    ++ lib.optionals withGeolocation [ libmaxminddb ]
    ++ lib.optionals stdenv.isDarwin [ gettext ];

  meta = {
    description = "Real-time web log analyzer and interactive viewer that runs in a terminal in *nix systems";
    homepage    = "https://goaccess.io";
    changelog   = "https://github.com/allinurl/goaccess/raw/v${version}/ChangeLog";
    license     = lib.licenses.mit;
    platforms   = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ ederoyd46 ];
  };
}
