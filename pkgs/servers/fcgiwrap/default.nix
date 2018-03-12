{ stdenv, fetchurl, fetchpatch, systemd, fcgi, autoreconfHook, pkgconfig }:

stdenv.mkDerivation rec {
  name = "fcgiwrap-${version}";
  version = "1.1.0";

  src = fetchurl {
    url = "http://github.com/gnosek/fcgiwrap/archive/${version}.tar.gz";
    sha256 = "07y6s4mm86cv7p1ljz94sxnqa89y9amn3vzwsnbq5hrl4vdy0zac";
  };

  NIX_CFLAGS_COMPILE = "-Wno-error=implicit-fallthrough";
  configureFlags = [ "--with-systemd" "--with-systemdsystemunitdir=$(out)/etc/systemd/system" ];

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ systemd fcgi ];

  patches = [
    (fetchpatch {
      url = https://sources.debian.org/data/main/f/fcgiwrap/1.1.0-10/debian/patches/declare_cgi_error_noreturn.patch;
      sha256 = "07mc9jb0f2kzb4pvaxk0pxlb8fjmg42n9j3im548arqzbay2cfr8";
    })
  ];

  # systemd 230 no longer has libsystemd-daemon as a separate entity from libsystemd
  postPatch = ''
    substituteInPlace configure.ac --replace libsystemd-daemon libsystemd
  '';

  meta = with stdenv.lib; {
    homepage = https://nginx.localdomain.pl/wiki/FcgiWrap;
    description = "Simple server for running CGI applications over FastCGI";
    maintainers = with maintainers; [ lethalman ];
    platforms = with platforms; linux;
  };
}
