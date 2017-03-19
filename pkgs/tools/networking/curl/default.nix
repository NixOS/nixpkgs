{ stdenv, fetchurl, pkgconfig, perl
, http2Support ? true, nghttp2
, idnSupport ? false, libidn ? null
, ldapSupport ? false, openldap ? null
, zlibSupport ? false, zlib ? null
, sslSupport ? false, openssl ? null
, gnutlsSupport ? false, gnutls ? null
, scpSupport ? false, libssh2 ? null
, gssSupport ? false, gss ? null
, c-aresSupport ? false, c-ares ? null
}:

assert http2Support -> nghttp2 != null;
assert idnSupport -> libidn != null;
assert ldapSupport -> openldap != null;
assert zlibSupport -> zlib != null;
assert sslSupport -> openssl != null;
assert !(gnutlsSupport && sslSupport);
assert gnutlsSupport -> gnutls != null;
assert scpSupport -> libssh2 != null;
assert c-aresSupport -> c-ares != null;

stdenv.mkDerivation rec {
  name = "curl-7.53.1";

  src = fetchurl {
    url = "http://curl.haxx.se/download/${name}.tar.bz2";
    sha256 = "1s1hyndva0yp62xy96pcp4anzrvw6cl0abjajim17sbmdp00fwhw";
  };

  patches = [ ];

  outputs = [ "bin" "dev" "out" "man" "devdoc" ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkgconfig perl ];

  # Zlib and OpenSSL must be propagated because `libcurl.la' contains
  # "-lz -lssl", which aren't necessary direct build inputs of
  # applications that use Curl.
  propagatedBuildInputs = with stdenv.lib;
    optional http2Support nghttp2 ++
    optional idnSupport libidn ++
    optional ldapSupport openldap ++
    optional zlibSupport zlib ++
    optional gssSupport gss ++
    optional c-aresSupport c-ares ++
    optional sslSupport openssl ++
    optional gnutlsSupport gnutls ++
    optional scpSupport libssh2;

  # for the second line see http://curl.haxx.se/mail/tracker-2014-03/0087.html
  preConfigure = ''
    sed -e 's|/usr/bin|/no-such-path|g' -i.bak configure
    rm src/tool_hugehelp.c
  '';

  configureFlags = [
      # OS X does not have a default system bundle, so we assume cacerts is installed in the default nix-env profile
      # This sucks. We should probably just include the latest cacerts in the darwin bootstrap.
      "--with-ca-bundle=${if stdenv.isDarwin then "/nix/var/nix/profiles/default" else ""}/etc/ssl/certs/ca-${if stdenv.isDarwin then "bundle" else "certificates"}.crt"
      "--disable-manual"
      ( if sslSupport then "--with-ssl=${openssl.dev}" else "--without-ssl" )
      ( if gnutlsSupport then "--with-gnutls=${gnutls.dev}" else "--without-gnutls" )
      ( if scpSupport then "--with-libssh2=${libssh2.dev}" else "--without-libssh2" )
      ( if ldapSupport then "--enable-ldap" else "--disable-ldap" )
      ( if ldapSupport then "--enable-ldaps" else "--disable-ldaps" )
      ( if idnSupport then "--with-libidn=${libidn.dev}" else "--without-libidn" )
    ]
    ++ stdenv.lib.optional c-aresSupport "--enable-ares=${c-ares}"
    ++ stdenv.lib.optional gssSupport "--with-gssapi=${gss}";

  CXX = "g++";
  CXXCPP = "g++ -E";

  postInstall = ''
    moveToOutput bin/curl-config "$dev"
    sed '/^dependency_libs/s|${libssh2.dev}|${libssh2.out}|' -i "$out"/lib/*.la
  '' + stdenv.lib.optionalString gnutlsSupport ''
    ln $out/lib/libcurl.so $out/lib/libcurl-gnutls.so
    ln $out/lib/libcurl.so $out/lib/libcurl-gnutls.so.4
    ln $out/lib/libcurl.so $out/lib/libcurl-gnutls.so.4.4.0
  '';

  crossAttrs = {
    # We should refer to the cross built openssl
    # For the 'urandom', maybe it should be a cross-system option
    configureFlags = [
        ( if sslSupport then "--with-ssl=${openssl.crossDrv}" else "--without-ssl" )
        ( if gnutlsSupport then "--with-gnutls=${gnutls.crossDrv}" else "--without-gnutls" )
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
