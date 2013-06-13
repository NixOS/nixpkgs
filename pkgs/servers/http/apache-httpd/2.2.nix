{ stdenv, fetchurl, openssl, perl, zlib
, sslSupport, proxySupport ? true
, apr, aprutil, pcre
, ldapSupport ? true, openldap
, # Multi-processing module to use.  This is built into the server and
  # cannot be selected at runtime.
  mpm ? "prefork"
}:

assert sslSupport -> openssl != null;
assert ldapSupport -> aprutil.ldapSupport && openldap != null;
assert mpm == "prefork" || mpm == "worker" || mpm == "event";

stdenv.mkDerivation rec {
  version = "2.2.24";
  name = "apache-httpd-${version}";

  src = fetchurl {
    url = "mirror://apache/httpd/httpd-${version}.tar.bz2";
    sha1 = "f73bce14832ec40c1aae68f4f8c367cab2266241";
  };

  outputs = [ "dev" "out" "doc" ];

  buildInputs = [perl apr aprutil pcre] ++
    stdenv.lib.optional sslSupport openssl;

  # An apr-util header file includes an apr header file
  # through #include "" (quotes)
  # passing simply CFLAGS did not help, then I go by NIX_CFLAGS_COMPILE
  NIX_CFLAGS_COMPILE = "-iquote ${apr}/include/apr-1";

  # Required for ‘pthread_cancel’.
  NIX_LDFLAGS = "-lgcc_s";

  configureFlags = ''
    --with-z=${zlib}
    --with-pcre=${pcre}
    --enable-mods-shared=all
    --enable-authn-alias
    ${if proxySupport then "--enable-proxy" else ""}
    ${if sslSupport then "--enable-ssl --with-ssl=${openssl}" else ""}
    ${if ldapSupport then "--enable-ldap --enable-authnz-ldap" else ""}
    --with-mpm=${mpm}
  '';

  preConfigure =
    ''
      makeFlagsArray+=("installbuilddir=$dev/share/build")
    '';

  enableParallelBuilding = true;

  stripDebugList = "lib modules bin";

  postInstall = ''
    mkdir -p $doc/share/doc/httpd
    mv $out/manual $doc/share/doc/httpd
    mkdir -p $out/share # FIXME, hack
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
