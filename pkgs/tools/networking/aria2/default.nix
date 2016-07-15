{ stdenv, fetchFromGitHub, fetchpatch, pkgconfig, autoreconfHook
, openssl, c-ares, libxml2, sqlite, zlib, libssh2
, Security
}:

stdenv.mkDerivation rec {
  name = "aria2-${version}";
  version = "1.24.0";

  src = fetchFromGitHub {
    owner = "aria2";
    repo = "aria2";
    rev = "release-${version}";
    sha256 = "0sb8s2rf2l0x7m8fx8kys7vad0lfw3k9071iai03kxplkdvg96n9";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];

  buildInputs = [ openssl c-ares libxml2 sqlite zlib libssh2 ] ++
    stdenv.lib.optional stdenv.isDarwin Security;

  patches = stdenv.lib.optionals stdenv.isDarwin [
    (fetchpatch {
      url = https://github.com/aria2/aria2/commit/1e59e357af626edc870b7f53c1ae8083658d0d1a.patch;
      sha256 = "1xjj4ll1v6adl6vdkl84v0mh7ma6p469ph1wpvksxrq6qp8345qj";
    })
  ];

  configureFlags = [ "--with-ca-bundle=/etc/ssl/certs/ca-certificates.crt" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://aria2.github.io;
    description = "A lightweight, multi-protocol, multi-source, command-line download utility";
    maintainers = with maintainers; [ koral jgeerds ];
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
