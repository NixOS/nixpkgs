{ stdenv, fetchurl, pkgconfig, openssl, perl, zlib
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
  version = "2.2.31";
  name = "apache-httpd-${version}";

  src = fetchurl {
    url = "mirror://apache/httpd/httpd-${version}.tar.bz2";
    sha256 = "1b165zi7jrrlz5wmyy3b34lcs3dl4g0dymfb0qxwdnimylcrsbzk";
  };

  # FIXME: -dev depends on -doc
  outputs = [ "dev" "out" "doc" ];
  setOutputFlags = false; # it would move $out/modules, etc.

  propagatedBuildInputs = [ apr ]; # otherwise mod_* fail to find includes often
  buildInputs = [ pkgconfig perl aprutil pcre zlib ] ++
    stdenv.lib.optional sslSupport openssl;

  # Required for ‘pthread_cancel’.
  NIX_LDFLAGS = (if stdenv.isDarwin then "" else "-lgcc_s");

  patchPhase = ''
    sed -i config.layout -e "s|installbuilddir:.*|installbuilddir: $dev/share/build|"
  '';

  preConfigure = ''
    configureFlags="$configureFlags --includedir=$dev/include"
  '';
  configureFlags = ''
    --with-z=${zlib.dev}
    --with-pcre=${pcre.dev}
    --enable-mods-shared=all
    --enable-authn-alias
    ${if proxySupport then "--enable-proxy" else ""}
    ${if sslSupport then "--enable-ssl --with-ssl=${openssl.dev}" else ""}
    ${if ldapSupport then "--enable-ldap --enable-authnz-ldap" else ""}
    --with-mpm=${mpm}
    --enable-cache
    --enable-disk-cache
    --enable-file-cache
    --enable-mem-cache
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
    inherit apr aprutil sslSupport proxySupport;
  };

  meta = {
    description = "Apache HTTPD, the world's most popular web server";
    branch      = "2.2";
    homepage    = http://httpd.apache.org/;
    license     = stdenv.lib.licenses.asl20;
    platforms   = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    maintainers = with stdenv.lib.maintainers; [ eelco lovek323 ];
  };
}
