{ lib, stdenv, fetchurl, perl, zlib, apr, aprutil, pcre, libiconv, lynx
, nixosTests
, proxySupport ? true
, sslSupport ? true, openssl
, http2Support ? true, nghttp2
, ldapSupport ? true, openldap
, libxml2Support ? true, libxml2
, brotliSupport ? true, brotli
, luaSupport ? false, lua5
}:

let inherit (lib) optional;
in

assert sslSupport -> aprutil.sslSupport && openssl != null;
assert ldapSupport -> aprutil.ldapSupport && openldap != null;
assert http2Support -> nghttp2 != null;

stdenv.mkDerivation rec {
  version = "2.4.49";
  pname = "apache-httpd";

  src = fetchurl {
    url = "mirror://apache/httpd/httpd-${version}.tar.bz2";
    sha256 = "0fqkfjcpdd40ji2279wfxh5hddb5jdxlnpjr0sbhva8fi7b6bfb5";
  };

  # FIXME: -dev depends on -doc
  outputs = [ "out" "dev" "man" "doc" ];
  setOutputFlags = false; # it would move $out/modules, etc.

  buildInputs = [perl] ++
    optional brotliSupport brotli ++
    optional sslSupport openssl ++
    optional ldapSupport openldap ++    # there is no --with-ldap flag
    optional libxml2Support libxml2 ++
    optional http2Support nghttp2 ++
    optional stdenv.isDarwin libiconv;

  prePatch = ''
    sed -i config.layout -e "s|installbuilddir:.*|installbuilddir: $dev/share/build|"
    sed -i support/apachectl.in -e 's|@LYNX_PATH@|${lynx}/bin/lynx|'
  '';

  # Required for ‘pthread_cancel’.
  NIX_LDFLAGS = lib.optionalString (!stdenv.isDarwin) "-lgcc_s";

  configureFlags = [
    "--with-apr=${apr.dev}"
    "--with-apr-util=${aprutil.dev}"
    "--with-z=${zlib.dev}"
    "--with-pcre=${pcre.dev}"
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
    };
  };

  meta = with lib; {
    description = "Apache HTTPD, the world's most popular web server";
    homepage    = "http://httpd.apache.org/";
    license     = licenses.asl20;
    platforms   = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with maintainers; [ lovek323 peti ];
  };
}
