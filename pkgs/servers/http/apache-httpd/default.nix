{ stdenv, fetchurl, openssl, perl, zlib
, sslSupport, proxySupport ? true
, apr, aprutil, pcre
}:

assert sslSupport -> openssl != null;

stdenv.mkDerivation rec {
  version = "2.2.17";
  name = "apache-httpd-${version}";

  src = fetchurl {
    url = "mirror://apache/httpd/httpd-${version}.tar.bz2";
    sha256 = "017vc5g0dwjycai2qa8427vkw6wpa57ylhajw6nrmynq7qgg32l6";
  };

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
    license = "ASL2.0";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
