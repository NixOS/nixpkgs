{ lib, stdenv, fetchurl, perl, zlib, apr, aprutil, pcre2, libiconv, lynx, which, libxcrypt
, fetchpatch
, nixosTests
, proxySupport ? true
, sslSupport ? true, openssl
, modTlsSupport ? false, rustls-ffi, Foundation
, http2Support ? true, nghttp2
, ldapSupport ? true, openldap
, libxml2Support ? true, libxml2
, brotliSupport ? true, brotli
, luaSupport ? false, lua5
}:

stdenv.mkDerivation rec {
  pname = "apache-httpd";
  version = "2.4.58";

  src = fetchurl {
    url = "mirror://apache/httpd/httpd-${version}.tar.bz2";
    sha256 = "sha256-+hbXKgeCEKVMR91b7y+Lm4oB2UkJpRRTlWs+xkQupMU=";
  };

  # FIXME: -dev depends on -doc
  outputs = [ "out" "dev" "man" "doc" ];
  setOutputFlags = false; # it would move $out/modules, etc.

  nativeBuildInputs = [ which ];

  buildInputs = [ perl libxcrypt ] ++
    lib.optional brotliSupport brotli ++
    lib.optional sslSupport openssl ++
    lib.optional modTlsSupport rustls-ffi ++
    lib.optional (modTlsSupport && stdenv.isDarwin) Foundation ++
    lib.optional ldapSupport openldap ++    # there is no --with-ldap flag
    lib.optional libxml2Support libxml2 ++
    lib.optional http2Support nghttp2 ++
    lib.optional stdenv.isDarwin libiconv;

  patches = lib.optionals modTlsSupport [
    (fetchpatch {
      name = "compat-with-rustls-ffi-0.10.0.patch";
      url = "https://github.com/apache/httpd/commit/918620a183d843fb393ed939423a25d42c1044ec.patch";
      hash = "sha256-YZi3t++hjM0skisax2xuh9DifZVZjCjVn6XQr6QKGEs=";
    })
  ];

  postPatch = ''
    sed -i config.layout -e "s|installbuilddir:.*|installbuilddir: $dev/share/build|"
    sed -i support/apachectl.in -e 's|@LYNX_PATH@|${lynx}/bin/lynx|'
  '';

  # Required for ‘pthread_cancel’.
  NIX_LDFLAGS = lib.optionalString (!stdenv.isDarwin) "-lgcc_s";

  configureFlags = [
    "--with-apr=${apr.dev}"
    "--with-apr-util=${aprutil.dev}"
    "--with-z=${zlib.dev}"
    "--with-pcre=${pcre2.dev}/bin/pcre2-config"
    "--disable-maintainer-mode"
    "--disable-debugger-mode"
    "--enable-mods-shared=all"
    "--enable-mpms-shared=all"
    "--enable-cern-meta"
    "--enable-imagemap"
    "--enable-cgi"
    "--includedir=${placeholder "dev"}/include"
    (lib.enableFeature proxySupport "proxy")
    (lib.enableFeature sslSupport "ssl")
    (lib.enableFeature modTlsSupport "tls")
    (lib.withFeatureAs libxml2Support "libxml2" "${libxml2.dev}/include/libxml2")
    "--docdir=$(doc)/share/doc"

    (lib.enableFeature brotliSupport "brotli")
    (lib.withFeatureAs brotliSupport "brotli" brotli)

    (lib.enableFeature http2Support "http2")
    (lib.withFeature http2Support "nghttp2")

    (lib.enableFeature luaSupport "lua")
    (lib.withFeatureAs luaSupport "lua" lua5)
  ];

  enableParallelBuilding = true;

  stripDebugList = [ "lib" "modules" "bin" ];

  postInstall = ''
    mkdir -p $doc/share/doc/httpd
    mv $out/manual $doc/share/doc/httpd
    mkdir -p $dev/bin
    mv $out/bin/apxs $dev/bin/apxs
  '';

  passthru = {
    inherit apr aprutil sslSupport proxySupport ldapSupport luaSupport lua5;
    tests = {
      acme-integration = nixosTests.acme;
      proxy = nixosTests.proxy;
      php = nixosTests.php.httpd;
    };
  };

  meta = with lib; {
    description = "Apache HTTPD, the world's most popular web server";
    homepage    = "https://httpd.apache.org/";
    license     = licenses.asl20;
    platforms   = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ lovek323 ];
  };
}
