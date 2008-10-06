{ stdenv, fetchurl, openssl, perl, zlib
, sslSupport, proxySupport ? true
, apr, aprutil, pcre
}:

assert sslSupport -> openssl != null;

stdenv.mkDerivation {
  name = "apache-httpd-2.2.9";

  src = fetchurl {
    url = mirror://apache/httpd/httpd-2.2.9.tar.bz2;
    md5 = "3afa8137dc1999be695a20b62fdf032b";
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
