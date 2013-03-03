{ stdenv, fetchurl, perl, zlib, apr, aprutil, pcre
, proxySupport ? true
, sslSupport ? true, openssl
, ldapSupport ? true, openldap
, libxml2Support ? true, libxml2
, luaSupport ? false, lua5
}:

let optional       = stdenv.lib.optional;
    optionalString = stdenv.lib.optionalString;
in

assert sslSupport -> aprutil.sslSupport && openssl != null;
assert ldapSupport -> aprutil.ldapSupport && openldap != null;

stdenv.mkDerivation rec {
  version = "2.4.4";
  name = "apache-httpd-${version}";

  src = fetchurl {
    url = "mirror://apache/httpd/httpd-${version}.tar.bz2";
    sha256 = "0p35jy6mkb1q48bia719qxs5bwxv0wadyhxi61rsr93nrbgbvalj";
  };

  buildInputs = [perl] ++
    optional ldapSupport openldap ++    # there is no --with-ldap flag
    optional libxml2Support libxml2;

  # Required for ‘pthread_cancel’.
  NIX_LDFLAGS = "-lgcc_s";

  configureFlags = ''
    --with-apr=${apr}
    --with-apr-util=${aprutil}
    --with-z=${zlib}
    --with-pcre=${pcre}
    --disable-maintainer-mode
    --disable-debugger-mode
    --enable-mods-shared=all
    --enable-mpms-shared=all
    --enable-cern-meta
    --enable-imagemap
    --enable-cgi
    ${optionalString proxySupport "--enable-proxy"}
    ${optionalString sslSupport "--enable-ssl --with-ssl=${openssl}"}
    ${optionalString luaSupport "--enable-lua --with-lua=${lua5}"}
    ${optionalString libxml2Support "--with-libxml2=${libxml2}/include/libxml2"}
  '';

  postInstall = ''
    echo "removing manual"
    rm -rf $out/manual
  '';

  enableParallelBuilding = true;

  passthru = {
    inherit apr aprutil sslSupport proxySupport ldapSupport;
  };

  meta = {
    description = "Apache HTTPD, the world's most popular web server";
    homepage = "http://httpd.apache.org/";
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
