{stdenv, fetchurl, zlibSupport ? false, zlib, sslSupport ? false, openssl ? null}:

assert zlibSupport -> zlib != null;
assert sslSupport -> openssl != null;

stdenv.mkDerivation {
  name = "curl-7.17.1";
  src = fetchurl {
    url = http://curl.haxx.se/download/curl-7.17.1.tar.bz2;
    sha256 = "0yz50r75jhfr2ya6wqi6n90bn4ij30299pjglmlckzq6jp28wrkz";
  };
  buildInputs =
    stdenv.lib.optional zlibSupport zlib ++
    stdenv.lib.optional sslSupport openssl;
  configureFlags = "
    ${if sslSupport then "--with-ssl=${openssl}" else "--without-ssl"}
  ";
  CFLAGS = if stdenv ? isDietLibC then "-DHAVE_INET_NTOA_R_2_ARGS=1" else "";
  CXX = "g++";
  CXXCPP = "g++ -E";

  passthru = {
    inherit sslSupport openssl;
  };

  preConfigure = ''
    substituteInPlace configure --replace /usr/bin /no-such-path
  '';

  patches = [
    /* Fixes broken retry support when a timeout is used.  The
       select() system call (used to wait for the connection to come
       up) can return slightly before the computed deadline (a few
       milliseconds).  Curl will think the problem is something else,
       proceed with the next IP address (which usually doesn't exist),
       then barf with a CURLE_COULDNT_CONNECT error, which is
       considered non-transient so it won't retry. */
    ./connect-timeout.patch
  ];
}
