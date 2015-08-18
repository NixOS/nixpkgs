{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook, cppunit, libgcrypt
, c-ares, openssl, libxml2, sqlite, zlib }:

stdenv.mkDerivation rec {
  name = "aria2-${version}";
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "tatsuhiro-t";
    repo = "aria2";
    rev = "release-${version}";
    sha256 = "1k4b8jfg4wjsvybb7hysplp6h831allhiqdy9jwsyy0m0zmgk00a";
  };

  buildInputs = [
    pkgconfig autoreconfHook cppunit libgcrypt c-ares openssl libxml2
    sqlite zlib
  ];

  configureFlags = [ "--with-ca-bundle=/etc/ssl/certs/ca-certificates.crt" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/tatsuhiro-t/aria2;
    description = "A lightweight, multi-protocol, multi-source, command-line download utility";
    maintainers = with maintainers; [ koral jgeerds ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
