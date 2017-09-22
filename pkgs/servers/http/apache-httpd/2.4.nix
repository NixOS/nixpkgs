{ stdenv, fetchurl, perl, zlib, apr, aprutil, pcre, libiconv
, proxySupport ? true
, sslSupport ? true, openssl
, http2Support ? true, nghttp2
, ldapSupport ? true, openldap
, libxml2Support ? true, libxml2
, luaSupport ? false, lua5
, fetchpatch
}:

let optional       = stdenv.lib.optional;
    optionalString = stdenv.lib.optionalString;
in

assert sslSupport -> aprutil.sslSupport && openssl != null;
assert ldapSupport -> aprutil.ldapSupport && openldap != null;
assert http2Support -> nghttp2 != null;

stdenv.mkDerivation rec {
  version = "2.4.27";
  name = "apache-httpd-${version}";

  src = fetchurl {
    url = "mirror://apache/httpd/httpd-${version}.tar.bz2";
    sha1 = "699e4e917e8fb5fd7d0ce7e009f8256ed02ec6fc";
  };

  # FIXME: -dev depends on -doc
  outputs = [ "out" "dev" "man" "doc" ];
  setOutputFlags = false; # it would move $out/modules, etc.

  buildInputs = [perl] ++
    optional sslSupport openssl ++
    optional ldapSupport openldap ++    # there is no --with-ldap flag
    optional libxml2Support libxml2 ++
    optional http2Support nghttp2 ++
    optional stdenv.isDarwin libiconv;

  prePatch = ''
    sed -i config.layout -e "s|installbuilddir:.*|installbuilddir: $dev/share/build|"
  '';

  patches = [
    (fetchpatch {
      name = "CVE-2017-9798.patch";
      url = "https://svn.apache.org/viewvc/httpd/httpd/branches/2.4.x/server/core.c?r1=1805223&r2=1807754&pathrev=1807754&view=patch";
      sha256 = "00hbq5szgav91kwsc30jdjvgd3vbgm8n198yna8bcs33p434v25k";
      stripLen = 3;
     })
  ];

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
