{ stdenv, fetchurl
, zlibSupport ? false, zlib ? null
, sslSupport ? false, openssl ? null
, linkStatic ? false
}:

assert zlibSupport -> zlib != null;
assert sslSupport -> openssl != null;

stdenv.mkDerivation rec {
  name = "curl-7.21.0";
  
  src = fetchurl {
    url = "http://curl.haxx.se/download/${name}.tar.bz2";
    sha256 = "1fl7sh38i746b57aqjqjaykwq4rhm2p1phzrgnc2h6wm2k2b95gy";
  };
  
  # Zlib and OpenSSL must be propagated because `libcurl.la' contains
  # "-lz -lssl", which aren't necessary direct build inputs of
  # applications that use Curl.
  propagatedBuildInputs =
    stdenv.lib.optional zlibSupport zlib ++
    stdenv.lib.optional sslSupport openssl;
    
  configureFlags = ''
    ${if sslSupport then "--with-ssl=${openssl}" else "--without-ssl"}
    ${if linkStatic then "--enable-static --disable-shared" else ""}
  '';

  dontDisableStatic = if linkStatic then true else false;
  
  CFLAGS = if stdenv ? isDietLibC then "-DHAVE_INET_NTOA_R_2_ARGS=1" else "";
  LDFLAGS = if linkStatic then "-static" else "";
  CXX = "g++";
  CXXCPP = "g++ -E";

  # libtool hack to get a static binary. Notice that to 'configure' I passed
  # other LDFLAGS, because it doesn't use libtool for linking in the tests.
  makeFlags = if linkStatic then "LDFLAGS=-all-static" else "";

  crossAttrs = {
    # We should refer to the cross built openssl
    # For the 'urandom', maybe it should be a cross-system option
    configureFlags = ''
      ${if sslSupport then "--with-ssl=${openssl.hostDrv}" else "--without-ssl"}
      ${if linkStatic then "--enable-static --disable-shared" else ""}
      --with-random /dev/urandom
    '';
  };

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

  meta = {
    description = "A command line tool for transferring files with URL syntax";
    homepage = http://curl.haxx.se/;
  };
}
