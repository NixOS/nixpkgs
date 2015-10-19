{ stdenv, fetchurl, libssl, perl, zlib
, sslSupport, proxySupport ? true
, apr, aprutil, pcre
, ldapSupport ? true, openldap
, # Multi-processing module to use.  This is built into the server and
  # cannot be selected at runtime.
  mpm ? "prefork"
}:

assert sslSupport -> libssl != null;
assert ldapSupport -> aprutil.ldapSupport && openldap != null;
assert mpm == "prefork" || mpm == "worker" || mpm == "event";

stdenv.mkDerivation rec {
  version = "2.2.31";
  name = "apache-httpd-${version}";

  src = fetchurl {
    url = "mirror://apache/httpd/httpd-${version}.tar.bz2";
    sha256 = "1b165zi7jrrlz5wmyy3b34lcs3dl4g0dymfb0qxwdnimylcrsbzk";
  };

  buildInputs = [perl apr aprutil pcre] ++
    stdenv.lib.optional sslSupport libssl;

  # An apr-util header file includes an apr header file
  # through #include "" (quotes)
  # passing simply CFLAGS did not help, then I go by NIX_CFLAGS_COMPILE
  NIX_CFLAGS_COMPILE = "-iquote ${apr}/include/apr-1";

  # Required for ‘pthread_cancel’.
  NIX_LDFLAGS = (if stdenv.isDarwin then "" else "-lgcc_s");

  configureFlags = ''
    --with-z=${zlib}
    --with-pcre=${pcre}
    --enable-mods-shared=all
    --enable-authn-alias
    ${if proxySupport then "--enable-proxy" else ""}
    ${if sslSupport then "--enable-ssl --with-ssl=${libssl}" else ""}
    ${if ldapSupport then "--enable-ldap --enable-authnz-ldap" else ""}
    --with-mpm=${mpm}
    --enable-cache
    --enable-disk-cache
    --enable-file-cache
    --enable-mem-cache
  '';

  enableParallelBuilding = true;

  postInstall = ''
    echo "removing manual"
    rm -rf $out/manual
  '';

  passthru = {
    inherit apr aprutil sslSupport proxySupport;
  };

  meta = {
    description = "Apache HTTPD, the world's most popular web server";
    branch      = "2.2";
    homepage    = http://httpd.apache.org/;
    license     = stdenv.lib.licenses.asl20;
    platforms   = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    maintainers = with stdenv.lib.maintainers; [ eelco simons lovek323 ];
  };
}
