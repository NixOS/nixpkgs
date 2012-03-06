{ stdenv, fetchurl
, zlibSupport ? false, zlib ? null
, sslSupport ? false, openssl ? null
, scpSupport ? false, libssh2 ? null
, linkStatic ? false
}:

assert zlibSupport -> zlib != null;
assert sslSupport -> openssl != null;
assert scpSupport -> libssh2 != null;

stdenv.mkDerivation rec {
  name = "curl-7.22.0";

  src = fetchurl {
    url = "http://curl.haxx.se/download/${name}.tar.bz2";
    sha256 = "04ji7v06f33y6plvikwj283ad6fxxxjpm7as9xw25c924f3dm85x";
  };

  # Zlib and OpenSSL must be propagated because `libcurl.la' contains
  # "-lz -lssl", which aren't necessary direct build inputs of
  # applications that use Curl.
  propagatedBuildInputs =
    stdenv.lib.optional zlibSupport zlib ++
    stdenv.lib.optional sslSupport openssl;

  configureFlags = ''
    ${if sslSupport then "--with-ssl=${openssl}" else "--without-ssl"}
    ${if scpSupport then "--with-libssh2=${libssh2}" else "--without-libssh2"}
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
    sed -e 's|/usr/bin|/no-such-path|g' -i.bak configure
  '';

  meta = {
    description = "A command line tool for transferring files with URL syntax";
    homepage = http://curl.haxx.se/;
  };
}
