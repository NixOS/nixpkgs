{ stdenv, fetchurl, systemd, fcgi, autoreconfHook, pkgconfig }:

stdenv.mkDerivation rec {
  name = "fcgiwrap-${version}";
  version = "1.1.0";

  src = fetchurl {
    url = "http://github.com/gnosek/fcgiwrap/archive/${version}.tar.gz";
    sha256 = "07y6s4mm86cv7p1ljz94sxnqa89y9amn3vzwsnbq5hrl4vdy0zac";
  };

  configureFlags = [ "--with-systemd" "--with-systemdsystemunitdir=$(out)/etc/systemd/system" ];

  buildInputs = [ autoreconfHook systemd fcgi pkgconfig ];

  meta = with stdenv.lib; {
    homepage = https://nginx.localdomain.pl/wiki/FcgiWrap;
    description = "Simple server for running CGI applications over FastCGI";
    maintainers = with maintainers; [ lethalman ];
  };
}
