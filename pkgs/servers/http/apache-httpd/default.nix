{ stdenv, fetchurl, openssl, perl, zlib
, sslSupport, proxySupport ? true
, apr, aprutil, pcre
, ldapSupport ? true, openldap
}:

assert sslSupport -> openssl != null;
assert ldapSupport -> aprutil.ldapSupport && openldap != null;

stdenv.mkDerivation rec {
  version = "2.2.19";
  name = "apache-httpd-${version}";

  src = fetchurl {
    url = "mirror://apache/httpd/httpd-${version}.tar.bz2";
    sha1 = "5676da63f3203129287d7c09a16cf523c00ec6cf";
  };

  buildInputs = [perl apr aprutil pcre] ++
    stdenv.lib.optional sslSupport openssl;

  # An apr-util header file includes an apr header file
  # through #include "" (quotes)
  # passing simply CFLAGS did not help, then I go by NIX_CFLAGS_COMPILE
  NIX_CFLAGS_COMPILE = "-iquote ${apr}/include/apr-1";

  configureFlags = ''
    --with-z=${zlib}
    --with-pcre=${pcre}
    --enable-mods-shared=all
    --enable-authn-alias
    ${if proxySupport then "--enable-proxy" else ""}
    ${if sslSupport then "--enable-ssl --with-ssl=${openssl}" else ""}
    ${if ldapSupport then "--enable-ldap --enable-authnz-ldap" else ""}
  '';

  postInstall = ''
    echo "removing manual"
    rm -rf $out/manual
  '';

  passthru = {
    inherit apr aprutil sslSupport proxySupport;
  };

  meta = {
    description = "Apache HTTPD, the world's most popular web server";
    homepage = http://httpd.apache.org/;
    license = "ASL2.0";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
