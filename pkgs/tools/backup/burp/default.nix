{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, acl, librsync, ncurses, openssl, zlib, uthash }:

stdenv.mkDerivation rec {
  name = "burp-${version}";
  version = "2.1.28";

  src = fetchFromGitHub {
    owner = "grke";
    repo = "burp";
    rev = version;
    sha256 = "1i8j15pmnn9cn6cd4dnp28qbisq8cl9l4y3chsmil4xqljr9fi5x";
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
