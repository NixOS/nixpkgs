{ stdenv, fetchurl, pkgconfig, autoreconfHook
, openssl, c-ares, libxml2, sqlite, zlib, libssh2
}:

stdenv.mkDerivation rec {
  name = "aria2-${version}";
  version = "1.19.2";

  src = fetchurl {
    url = "https://github.com/tatsuhiro-t/aria2/releases/download/release-${version}/${name}.tar.xz";
    sha256 = "0gnm1b7yp5q6fcajz1ln2f1rv64p6dv0nz9bcwpqrkcmsinlh19n";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl c-ares libxml2 sqlite zlib libssh2 ];

  configureFlags = [ "--with-ca-bundle=/etc/ssl/certs/ca-certificates.crt" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/tatsuhiro-t/aria2;
    description = "A lightweight, multi-protocol, multi-source, command-line download utility";
    maintainers = with maintainers; [ koral jgeerds ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
