{ stdenv, fetchurl, openssl, zlib, pcre, postgresql, libxml2, libxslt,
gd, geoip, perl }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "openresty";
  version = "1.15.8.2";

  src = fetchurl {
    url = "https://openresty.org/download/openresty-${version}.tar.gz";
    sha256 = "05jxrb8hv758nm38jil8n63q1nhrz3d249bsrwc7maa7sn24wss3";
  };

  buildInputs = [ openssl zlib pcre libxml2 libxslt gd geoip postgresql ];
  nativeBuildInputs = [ perl ];

  NIX_CFLAGS_COMPILE = "-I${libxml2.dev}/include/libxml2";

  preConfigure = ''
    patchShebangs .
  '';

  configureFlags = [
    "--with-pcre-jit"
    "--with-http_ssl_module"
    "--with-http_v2_module"
    "--with-http_realip_module"
    "--with-http_addition_module"
    "--with-http_xslt_module"
    "--with-http_image_filter_module"
    "--with-http_geoip_module"
    "--with-http_sub_module"
    "--with-http_dav_module"
    "--with-http_flv_module"
    "--with-http_mp4_module"
    "--with-http_gunzip_module"
    "--with-http_gzip_static_module"
    "--with-http_auth_request_module"
    "--with-http_random_index_module"
    "--with-http_secure_link_module"
    "--with-http_degradation_module"
    "--with-http_stub_status_module"
    "--with-http_postgres_module"
    "--with-ipv6"
  ];

  enableParallelBuilding = true;

  postInstall = ''
    ln -s $out/luajit/bin/luajit-2.1.0-beta3 $out/bin/luajit-openresty
    ln -s $out/nginx/sbin/nginx $out/bin/nginx
  '';

  meta = {
    description = "A fast web application server built on Nginx";
    homepage    = http://openresty.org;
    license     = licenses.bsd2;
    platforms   = platforms.all;
    maintainers = with maintainers; [ thoughtpolice lblasc ];
  };
}
