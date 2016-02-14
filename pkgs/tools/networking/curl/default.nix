{ stdenv, fetchurl, pkgconfig
, idnSupport ? false, libidn ? null
, ldapSupport ? false, openldap ? null
, zlibSupport ? false, zlib ? null
, sslSupport ? false, openssl ? null
, scpSupport ? false, libssh2 ? null
, gssSupport ? false, gss ? null
, c-aresSupport ? false, c-ares ? null
}:

assert idnSupport -> libidn != null;
assert ldapSupport -> openldap != null;
assert zlibSupport -> zlib != null;
assert sslSupport -> openssl != null;
assert scpSupport -> libssh2 != null;
assert c-aresSupport -> c-ares != null;

stdenv.mkDerivation rec {
  name = "curl-7.45.0";

  src = fetchurl {
    url = "http://ngcobalt13.uxnr.de/mirror/curl/${name}.tar.bz2";
    sha256 = "1slq5c0v9wa8hajgimhkxhvsrd07jmih8sa3gjsl597qp5k4w5b5";
  };

  outputs = [ "dev" "out" "bin" "man" "docdev" ];

  nativeBuildInputs = [ pkgconfig ];
  # Zlib and OpenSSL must be propagated because `libcurl.la' contains
  # "-lz -lssl", which aren't necessary direct build inputs of
  # applications that use Curl.
  propagatedBuildInputs = with stdenv.lib;
    optional idnSupport libidn ++
    optional ldapSupport openldap ++
    optional zlibSupport zlib ++
    optional gssSupport gss ++
    optional c-aresSupport c-ares ++
    optional sslSupport openssl ++
    optional scpSupport libssh2;

  # for the second line see http://curl.haxx.se/mail/tracker-2014-03/0087.html
  preConfigure = ''
    sed -e 's|/usr/bin|/no-such-path|g' -i.bak configure
    rm src/tool_hugehelp.c
  '';

  # make curl honor CURL_CA_BUNDLE & SSL_CERT_FILE
  postConfigure = ''
    echo  '#define CURL_CA_BUNDLE (getenv("CURL_CA_BUNDLE") ? getenv("CURL_CA_BUNDLE") : getenv("SSL_CERT_FILE"))' >> lib/curl_config.h
  '';

  configureFlags = [
      "--disable-manual"
      ( if sslSupport then "--with-ssl=${openssl}" else "--without-ssl" )
      ( if scpSupport then "--with-libssh2=${libssh2}" else "--without-libssh2" )
      ( if ldapSupport then "--enable-ldap" else "--disable-ldap" )
      ( if ldapSupport then "--enable-ldaps" else "--disable-ldaps" )
      ( if idnSupport then "--with-libidn=${libidn}" else "--without-libidn" )
    ]
    ++ stdenv.lib.optional c-aresSupport "--enable-ares=${c-ares}"
    ++ stdenv.lib.optional gssSupport "--with-gssapi=${gss}";

  CXX = "g++";
  CXXCPP = "g++ -E";

  postInstall = ''
    moveToOutput bin/curl-config "$dev"
    sed '/^dependency_libs/s|${libssh2.dev}|${libssh2.out}|' -i "$out"/lib/*.la
  '';

  crossAttrs = {
    # We should refer to the cross built openssl
    # For the 'urandom', maybe it should be a cross-system option
    configureFlags = [
        ( if sslSupport then "--with-ssl=${openssl.crossDrv}" else "--without-ssl" )
        "--with-random /dev/urandom"
      ];
  };

  passthru = {
    inherit sslSupport openssl;
  };

  meta = with stdenv.lib; {
    description = "A command line tool for transferring files with URL syntax";
    homepage    = http://curl.haxx.se/;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.all;
  };
}
