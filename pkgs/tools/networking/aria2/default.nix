{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook
, openssl, c-ares, libxml2, sqlite, zlib, libssh2
, Security
}:

stdenv.mkDerivation rec {
  name = "aria2-${version}";
  version = "1.31.0";

  src = fetchFromGitHub {
    owner = "aria2";
    repo = "aria2";
    rev = "release-${version}";
    sha256 = "0d7z4bss1plkvlw5kfwzivxryrh13zi58ii3vf8q4csaz4yqhcjy";
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
