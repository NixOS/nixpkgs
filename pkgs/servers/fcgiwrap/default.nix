{ lib, stdenv, fetchurl, systemd, fcgi, autoreconfHook, pkg-config }:

stdenv.mkDerivation rec {
  pname = "fcgiwrap";
  version = "1.1.0";

  src = fetchurl {
    url = "https://github.com/gnosek/fcgiwrap/archive/${version}.tar.gz";
    sha256 = "07y6s4mm86cv7p1ljz94sxnqa89y9amn3vzwsnbq5hrl4vdy0zac";
  };

  NIX_CFLAGS_COMPILE = "-Wno-error=implicit-fallthrough";
  configureFlags = [ "--with-systemd" "--with-systemdsystemunitdir=$(out)/etc/systemd/system" ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ systemd fcgi ];

  # systemd 230 no longer has libsystemd-daemon as a separate entity from libsystemd
  postPatch = ''
    substituteInPlace configure.ac --replace libsystemd-daemon libsystemd
  '';

  meta = with lib; {
    homepage = "https://nginx.localdomain.pl/wiki/FcgiWrap";
    description = "Simple server for running CGI applications over FastCGI";
    maintainers = with maintainers; [ ];
    platforms = with platforms; linux;
    license = licenses.mit;
  };
}
