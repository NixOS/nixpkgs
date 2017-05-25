{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook
, openssl, c-ares, libxml2, sqlite, zlib, libssh2
, Security
}:

stdenv.mkDerivation rec {
  name = "aria2-${version}";
  version = "1.32.0";

  src = fetchFromGitHub {
    owner = "aria2";
    repo = "aria2";
    rev = "release-${version}";
    sha256 = "098ahj7nyf5c70221aq5q3aqllb94frz9lzig8rkhqfsa4mmslg5";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];

  buildInputs = [ openssl c-ares libxml2 sqlite zlib libssh2 ] ++
    stdenv.lib.optional stdenv.isDarwin Security;

  configureFlags = [ "--with-ca-bundle=/etc/ssl/certs/ca-certificates.crt" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://aria2.github.io;
    description = "A lightweight, multi-protocol, multi-source, command-line download utility";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ koral jgeerds ];
  };
}
