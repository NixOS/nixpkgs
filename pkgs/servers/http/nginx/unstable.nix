{ stdenv, fetchurl, fetchFromGitHub, openssl, zlib, pcre, libxml2, libxslt, expat
, gd, geoip, luajit
, rtmp ? false
, fullWebDAV ? false
, syslog ? false
, moreheaders ? false
, echo ? false
, ngx_lua ? false }:

with stdenv.lib;

let
  version = "1.7.7";
  mainSrc = fetchurl {
    url = "http://nginx.org/download/nginx-${version}.tar.gz";
    sha256 = "1lmzq36ysi0hwvqpiaz0dpmwvdwbrn9aw1rm1xcabkl2g855l0by";
  };

  rtmp-ext = fetchFromGitHub {
    owner = "arut";
    repo = "nginx-rtmp-module";
    rev = "v1.1.5";
    sha256 = "1d9ws4prxz22yq3nhh5h18jrs331zivrdh784l6wznc1chg3gphn";
  };

  dav-ext = fetchFromGitHub {
    owner = "arut";
    repo = "nginx-dav-ext-module";
    rev = "v0.0.3";
    sha256 = "1qck8jclxddncjad8yv911s9z7lrd58bp96jf13m0iqk54xghx91";
  };

  syslog-ext = fetchFromGitHub {
    owner = "yaoweibin";
    repo = "nginx_syslog_patch";
    rev = "v0.25";
    sha256 = "0734f884838wcjyrrddn8wzj834wid1zffrk093jrx18447cryxl";
  };

  moreheaders-ext = fetchFromGitHub {
    owner = "openresty";
    repo = "headers-more-nginx-module";
    rev = "v0.25";
    sha256 = "1d71y1i0smi4gkzz731fhn58gr03b3s6jz6ipnfzxxaizmgxm3rb";
  };

  echo-ext = fetchFromGitHub {
    owner = "openresty";
    repo = "echo-nginx-module";
    rev = "v0.56";
    sha256 = "03vaf1ffhkj2s089f90h45n079h3zw47h6y5zpk752f4ydiagpgd";
  };

  develkit-ext = fetchFromGitHub {
    owner = "simpl";
    repo = "ngx_devel_kit";
    rev = "v0.2.19";
    sha256 = "1cqcasp4lc6yq5pihfcdw4vp4wicngvdc3nqg3bg52r63c1qrz76";
  };

  lua-ext = fetchFromGitHub {
    owner = "openresty";
    repo = "lua-nginx-module";
    rev = "v0.9.12";
    sha256 = "0r07q1n3nvi7m3l8zk7nfk0z9kjhqknav61ys9lshh2ylsmz1lf4";
  };

in

stdenv.mkDerivation rec {
  name = "nginx-${version}";
  src = mainSrc;

  buildInputs =
    [ openssl zlib pcre libxml2 libxslt gd geoip
    ] ++ optional fullWebDAV expat
      ++ optional ngx_lua luajit;

  LUAJIT_LIB = if ngx_lua then "${luajit}/lib" else "";
  LUAJIT_INC = if ngx_lua then "${luajit}/include/luajit-2.0" else "";

  patches = if syslog then [ "${syslog-ext}/syslog-1.5.6.patch" ] else [];

  configureFlags = [
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
    # Install destination problems
    # "--with-http_perl_module"
  ] ++ optional rtmp "--add-module=${rtmp-ext}"
    ++ optional fullWebDAV "--add-module=${dav-ext}"
    ++ optional syslog "--add-module=${syslog-ext}"
    ++ optional moreheaders "--add-module=${moreheaders-ext}"
    ++ optional echo "--add-module=${echo-ext}"
    ++ optional ngx_lua "--add-module=${develkit-ext} --add-module=${lua-ext}"
    ++ optional (elem stdenv.system (with platforms; linux ++ freebsd)) "--with-file-aio";


  additionalFlags = optionalString stdenv.isDarwin "-Wno-error=deprecated-declarations";

  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${libxml2}/include/libxml2 $additionalFlags"
  '';

  postInstall = ''
    mv $out/sbin $out/bin
  '';

  meta = {
    description = "A reverse proxy and lightweight webserver";
    homepage    = http://nginx.org;
    license     = licenses.bsd2;
    platforms   = platforms.all;
    maintainers = with maintainers; [ thoughtpolice raskin ];
  };
}
