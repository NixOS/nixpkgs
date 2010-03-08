{ stdenv, fetchurl, openssl, perl, zlib
, sslSupport, proxySupport ? true
, apr, aprutil, pcre
}:

assert sslSupport -> openssl != null;

stdenv.mkDerivation rec {
  version = "2.2.15";
  name = "apache-httpd-${version}";

  src = fetchurl {
    url = "mirror://apache/httpd/httpd-${version}.tar.bz2";
    sha1 = "5f0e973839ed2e38a4d03adba109ef5ce3381bc2";
  };

  #inherit sslSupport;

  buildInputs = [perl apr aprutil pcre] ++
    stdenv.lib.optional sslSupport openssl;

  configureFlags = ''
    --with-z=${zlib}
    --with-pcre=${pcre}
    --enable-mods-shared=all
    --enable-authn-alias
    ${if proxySupport then "--enable-proxy" else ""}
    ${if sslSupport then "--enable-ssl --with-ssl=${openssl}" else ""}
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
  };
}
