{ stdenv, fetchgit, acl, librsync, ncurses, openssl, zlib }:

stdenv.mkDerivation rec {
  name = "burp-1.4.40";

  src = fetchgit {
    url = "https://github.com/grke/burp.git";
    rev = "1e8eebac420f2b0dc29102602b7e5e437d58d5b7";
    sha256 = "02gpgcyg1x0bjk8349019zp3m002lmdhil6g6n8xv0kzz54v6gaw";
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
