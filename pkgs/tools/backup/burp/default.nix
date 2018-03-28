{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, acl, librsync, ncurses, openssl, zlib, uthash }:

stdenv.mkDerivation rec {
  name = "burp-${version}";
  version = "2.1.30";

  src = fetchFromGitHub {
    owner = "grke";
    repo = "burp";
    rev = version;
    sha256 = "0l9zcw50zr081ddspl6vnh6d6cwyzgqzg7n5pq92dwbmd64qpz9p";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ librsync ncurses openssl zlib uthash ]
    ++ stdenv.lib.optional (!stdenv.isDarwin) acl;

  configureFlags = [ "--localstatedir=/var" ];

  installFlags = [ "localstatedir=/tmp" ];

  meta = with stdenv.lib; {
    description = "BURP - BackUp and Restore Program";
    homepage    = http://burp.grke.org;
    license     = licenses.agpl3;
    maintainers = with maintainers; [ tokudan ];
    platforms   = platforms.all;
  };
}
