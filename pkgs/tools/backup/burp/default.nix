{ stdenv, fetchFromGitHub, autoreconfHook
, acl, librsync, ncurses, openssl, zlib, uthash }:

stdenv.mkDerivation rec {
  name = "burp-${version}";
  version = "2.0.54";

  src = fetchFromGitHub {
    owner = "grke";
    repo = "burp";
    rev = version;
    sha256 = "1z1w013hqxbfjgri0fan2570qwhgwvm4k4ghajbzqg8kly4fgk5x";
  };

  nativeBuildInputs = [ autoreconfHook ];
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
