{ lib, stdenv, fetchurl, ncurses, gettext, openssl, withGeolocation ? true, libmaxminddb }:

stdenv.mkDerivation rec {
  version = "1.5.2";
  pname = "goaccess";

  src = fetchurl {
    url = "https://tar.goaccess.io/goaccess-${version}.tar.gz";
    sha256 = "sha256-oM4vk5OyYiSE5GnpWoCd/VKt5NQgBJHkPt4fy1KrHIo=";
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
