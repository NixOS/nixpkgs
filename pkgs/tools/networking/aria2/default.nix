{ stdenv, fetchurl, pkgconfig, autoreconfHook
, openssl, c-ares, libxml2, sqlite, zlib, libssh2
, Security
}:

stdenv.mkDerivation rec {
  name = "aria2-${version}";
  version = "1.21.0";

  src = fetchurl {
    url = "https://github.com/tatsuhiro-t/aria2/releases/download/release-${version}/${name}.tar.xz";
    sha256 = "1035rzx9y7qv4p7cv04f461343dxha7ikprch059x2fci8n5yp12";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl c-ares libxml2 sqlite zlib libssh2 ] ++
    stdenv.lib.optional stdenv.isDarwin Security;

  configureFlags = [ "--with-ca-bundle=/etc/ssl/certs/ca-certificates.crt" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/tatsuhiro-t/aria2;
    description = "A lightweight, multi-protocol, multi-source, command-line download utility";
    maintainers = with maintainers; [ koral jgeerds ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
