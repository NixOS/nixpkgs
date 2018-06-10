{ stdenv, fetchurl, perl, zlib, apr, aprutil, pcre, libiconv
, proxySupport ? true
, sslSupport ? true, openssl
, http2Support ? true, nghttp2
, ldapSupport ? true, openldap
, libxml2Support ? true, libxml2
, brotliSupport ? true, brotli
, luaSupport ? false, lua5
}:

let inherit (stdenv.lib) optional optionalString;
in

assert sslSupport -> aprutil.sslSupport && openssl != null;
assert ldapSupport -> aprutil.ldapSupport && openldap != null;
assert http2Support -> nghttp2 != null;

stdenv.mkDerivation rec {
  version = "2.4.33";
  name = "apache-httpd-${version}";

  src = fetchurl {
    url = "mirror://apache/httpd/httpd-${version}.tar.bz2";
    sha256 = "de02511859b00d17845b9abdd1f975d5ccb5d0b280c567da5bf2ad4b70846f05";
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
  '';

  # Required for ‘pthread_cancel’.
  NIX_LDFLAGS = stdenv.lib.optionalString (!stdenv.isDarwin) "-lgcc_s";

  preConfigure = ''
    configureFlags="$configureFlags --includedir=$dev/include"
  '';

  configureFlags = ''
    --with-apr=${apr.dev}
    --with-apr-util=${aprutil.dev}
    --with-z=${zlib.dev}
    --with-pcre=${pcre.dev}
    --disable-maintainer-mode
    --disable-debugger-mode
    --enable-mods-shared=all
    --enable-mpms-shared=all
    --enable-cern-meta
    --enable-imagemap
    --enable-cgi
    ${optionalString brotliSupport "--enable-brotli --with-brotli=${brotli}"}
    ${optionalString proxySupport "--enable-proxy"}
    ${optionalString sslSupport "--enable-ssl"}
    ${optionalString http2Support "--enable-http2 --with-nghttp2"}
    ${optionalString luaSupport "--enable-lua --with-lua=${lua5}"}
    ${optionalString libxml2Support "--with-libxml2=${libxml2.dev}/include/libxml2"}
    --docdir=$(doc)/share/doc
  '';

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
