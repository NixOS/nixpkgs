{ stdenv, fetchurl, perl, zlib, apr, aprutil, pcre, libiconv, lynx
, proxySupport ? true
, sslSupport ? true, openssl
, http2Support ? true, nghttp2
, ldapSupport ? true, openldap
, libxml2Support ? true, libxml2
, brotliSupport ? true, brotli
, luaSupport ? false, lua5
}:

let inherit (stdenv.lib) optional;
in

assert sslSupport -> aprutil.sslSupport && openssl != null;
assert ldapSupport -> aprutil.ldapSupport && openldap != null;
assert http2Support -> nghttp2 != null;

stdenv.mkDerivation rec {
  version = "2.4.43";
  pname = "apache-httpd";

  src = fetchurl {
    url = "mirror://apache/httpd/httpd-${version}.tar.bz2";
    sha256 = "0hqgw47r3p3521ygkkqs8s30s5crm683081avj6330gwncm6b5x4";
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
  NIX_LDFLAGS = stdenv.lib.optionalString (!stdenv.isDarwin) "-lgcc_s";

  preConfigure = ''
    configureFlags="$configureFlags --includedir=$dev/include"
  '';

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
    (stdenv.lib.enableFeature proxySupport "proxy")
    (stdenv.lib.enableFeature sslSupport "ssl")
    (stdenv.lib.withFeatureAs libxml2Support "libxml2" "${libxml2.dev}/include/libxml2")
    "--docdir=$(doc)/share/doc"

    (stdenv.lib.enableFeature brotliSupport "brotli")
    (stdenv.lib.withFeatureAs brotliSupport "brotli" brotli)

    (stdenv.lib.enableFeature http2Support "http2")
    (stdenv.lib.withFeature http2Support "nghttp2")

    (stdenv.lib.enableFeature luaSupport "lua")
    (stdenv.lib.withFeatureAs luaSupport "lua" lua5)
  ];

  enableParallelBuilding = true;

  stripDebugList = "lib modules bin";

  postInstall = ''
    mkdir -p $doc/share/doc/httpd
    mv $out/manual $doc/share/doc/httpd
    mkdir -p $dev/bin
    mv $out/bin/apxs $dev/bin/apxs
  '';

  passthru = {
    inherit apr aprutil sslSupport proxySupport ldapSupport;
  };

  meta = with stdenv.lib; {
    description = "Apache HTTPD, the world's most popular web server";
    homepage    = http://httpd.apache.org/;
    license     = licenses.asl20;
    platforms   = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    maintainers = with maintainers; [ lovek323 peti ];
  };
}
