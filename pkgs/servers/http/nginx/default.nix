{ stdenv, fetchurl, openssl, zlib, pcre, libxml2, libxslt }:
stdenv.mkDerivation rec {
  name = "nginx-1.1.7";
  src = fetchurl {
    url = "http://nginx.org/download/${name}.tar.gz";
    sha256 = "1y0bzmrgnyqw8ghc508nipy5k46byrxc2sycqp35fdx0jmjz3h51";
  };
  buildInputs = [ openssl zlib pcre libxml2 libxslt ];

  configureFlags = [
    "--with-http_ssl_module"
    "--with-http_xslt_module"
    "--with-http_sub_module"
    "--with-http_dav_module"
    "--with-http_gzip_static_module"
    "--with-http_secure_link_module"
    # Install destination problems
    # "--with-http_perl_module" 
  ];

  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${libxml2}/include/libxml2"
  '';

  postInstall = ''
    mv $out/sbin $out/bin
  '';

  meta = {
    description = "nginx - 'engine x' - reverse proxy and lightweight webserver";
    maintainers = [
      stdenv.lib.maintainers.raskin
    ];
    platforms = with stdenv.lib.platforms; 
      all;
  };
}
