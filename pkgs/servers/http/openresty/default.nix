{ stdenv, fetchurl, fetchgit, openssl, zlib, pcre, libxml2, libxslt, gd, geoip
, perl }:

assert stdenv.isLinux;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "openresty-${version}";
  version = "1.9.3.1";

  src = fetchurl {
    url = "http://openresty.org/download/ngx_openresty-${version}.tar.gz";
    sha256 = "1fw8yxjndf5gsk44l4bsixm270fxv7f5cdiwzq9ps6j3hhgx5kyv";
  };

  buildInputs = [ openssl zlib pcre libxml2 libxslt gd geoip perl ];

  configureFlags = [
    "--with-pcre-jit"
    "--with-http_ssl_module"
    "--with-http_spdy_module"
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
    "--with-ipv6"
  ];

  postInstall = ''
    mv $out/nginx/sbin/nginx $out/bin
    mv $out/luajit/bin/luajit-2.1.0-alpha $out/bin/luajit-openresty
    ln -s $out/bin/nginx $out/bin/openresty
  '';

  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${libxml2.dev}/include/libxml2 $additionalFlags"
    export PATH="$PATH:${stdenv.cc.libc.bin}/bin"
    patchShebangs .
  '';

  meta = {
    description = "A fast web application server built on Nginx";
    homepage    = http://openresty.org;
    license     = licenses.bsd2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
