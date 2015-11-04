{ stdenv, fetchgit, acl, librsync, ncurses, openssl, zlib }:

stdenv.mkDerivation rec {
  name = "burp-1.4.40";

  src = fetchgit {
    url = "https://github.com/grke/burp.git";
    rev = "1e8eebac420f2b0dc29102602b7e5e437d58d5b7";
    sha256 = "201fe6daf598543eaf3c8cf3495812b3a65695c6841f555410aaaab1098b8f03";
  };

  patches = [ ./burp_1.4.40.patch ];

  buildInputs = [ librsync ncurses openssl zlib ]
    # next two lines copied from bacula, as burp needs acl as well
    # acl relies on attr, which I can't get to build on darwin
    ++ stdenv.lib.optional (!stdenv.isDarwin) acl;

  configureFlags = [
    "--sbindir=$out/bin"
  ];

  meta = with stdenv.lib; {
    description = "BURP - BackUp and Restore Program";
    homepage    = http://burp.grke.org;
    license     = licenses.agpl3;
    maintainers = with maintainers; [ tokudan ];
    platforms   = platforms.all;
  };
}
