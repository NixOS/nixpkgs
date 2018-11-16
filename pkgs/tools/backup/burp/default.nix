{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, acl, librsync, ncurses, openssl, zlib, uthash }:

stdenv.mkDerivation rec {
  name = "burp-${version}";
  version = "2.1.32";

  src = fetchFromGitHub {
    owner = "grke";
    repo = "burp";
    rev = version;
    sha256 = "1izs5vavffvj6z478s5x1shg71p2v5bnnrsam1avs21ylxbfnxi5";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ librsync ncurses openssl zlib uthash ]
    ++ stdenv.lib.optional (!stdenv.isDarwin) acl;

  configureFlags = [ "--localstatedir=/var" ];

  installFlags = [ "localstatedir=/tmp" ];

  meta = with stdenv.lib; {
    description = "BURP - BackUp and Restore Program";
    homepage    = https://burp.grke.org;
    license     = licenses.agpl3;
    maintainers = with maintainers; [ tokudan ];
    platforms   = platforms.all;
  };
}
