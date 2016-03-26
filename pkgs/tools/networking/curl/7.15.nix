{ stdenv, fetchurl
, zlibSupport ? false, zlib ? null
, sslSupport ? false, openssl ? null
, scpSupport ? false, libssh2 ? null
, gssSupport ? false, gss ? null
, c-aresSupport ? false, c-ares ? null
, linkStatic ? false
}:

assert zlibSupport -> zlib != null;
assert sslSupport -> openssl != null;
assert scpSupport -> libssh2 != null;
assert c-aresSupport -> c-ares != null;

stdenv.mkDerivation rec {
  name = "curl-7.15.0";

  src = fetchurl {
    url = "http://curl.haxx.se/download/archeology/${name}.tar.gz";
    sha256 = "061bgjm6rv0l9804vmm4jvr023l52qvmy9qq4zjv4lgqhlljvhz3";
  };

  patches = [ ./disable-ca-install.patch ];

  # Zlib and OpenSSL must be propagated because `libcurl.la' contains
  # "-lz -lssl", which aren't necessary direct build inputs of
  # applications that use Curl.
  propagatedBuildInputs = with stdenv.lib;
    optional zlibSupport zlib ++
    optional gssSupport gss ++
    optional c-aresSupport c-ares ++
    optional sslSupport openssl;

  preConfigure = ''
    sed -e 's|/usr/bin|/no-such-path|g' -i.bak configure
  '';

  configureFlags = [
      "--with-ca-bundle=/etc/ssl/certs/ca-certificates.crt"
      ( if sslSupport then "--with-ssl=${openssl}" else "--without-ssl" )
      ( if scpSupport then "--with-libssh2=${libssh2}" else "--without-libssh2" )
    ]
    ++ stdenv.lib.optional c-aresSupport "--enable-ares=${c-ares}"
    ++ stdenv.lib.optional gssSupport "--with-gssapi=${gss}"
    ++ stdenv.lib.optionals linkStatic [ "--enable-static" "--disable-shared" ]
  ;

  dontDisableStatic = linkStatic;

  LDFLAGS = if linkStatic then "-static" else "";
  CXX = "g++";
  CXXCPP = "g++ -E";

  # libtool hack to get a static binary. Notice that to 'configure' I passed
  # other LDFLAGS, because it doesn't use libtool for linking in the tests.
  makeFlags = if linkStatic then "LDFLAGS=-all-static" else "";

  crossAttrs = {
    # We should refer to the cross built openssl
    # For the 'urandom', maybe it should be a cross-system option
    configureFlags = [
        ( if sslSupport then "--with-ssl=${openssl.crossDrv}" else "--without-ssl" )
        "--with-random /dev/urandom"
      ]
      ++ stdenv.lib.optionals linkStatic [ "--enable-static" "--disable-shared" ]
    ;
  };

  passthru = {
    inherit sslSupport openssl;
  };

  meta = {
    homepage = "http://curl.haxx.se/";
    description = "A command line tool for transferring files with URL syntax";
    platforms = with stdenv.lib.platforms; allBut darwin;
    broken = true;
  };
}
