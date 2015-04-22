{ stdenv, fetchurl, fetchFromGitHub, openssl, zlib, pcre, libxml2, libxslt, expat
, gd, geoip, luajit
, rtmp ? false
, fullWebDAV ? false
, syslog ? false
, moreheaders ? false
, echo ? false
, ngx_lua ? false
, set_misc ? false
, fluent ? false
}:

with stdenv.lib;

let
  version = "1.8.0";
  mainSrc = fetchurl {
    url = "http://nginx.org/download/nginx-${version}.tar.gz";
    sha256 = "1mgkkmmwkhmpn68sdvbd73ssv6lpqhh864fsyvc1ij4hk4is3k13";
  };

  rtmp-ext = fetchFromGitHub {
    owner = "arut";
    repo = "nginx-rtmp-module";
    rev = "v1.1.7";
    sha256 = "0i0fa1znkj7cipy5nlkw4k40klhp9jzk28wxy2vrvd2jvh91x3ma";
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
    rev = "3ca5ba65541637f74467038aa032e2586321d0cb";
    sha256 = "0y8dxkx8m1jw4v5zsvw1gfah9vh3ryq0hfmrcbjzcmwp5b5lb1i8";
  };

  moreheaders-ext = fetchFromGitHub {
    owner = "openresty";
    repo = "headers-more-nginx-module";
    rev = "v0.26";
    sha256 = "01wkqhk8mk8jgmzi7jbzmg5kamffx3lmhj5yfwryvnvs6xqs74wn";
  };

  echo-ext = fetchFromGitHub {
    owner = "openresty";
    repo = "echo-nginx-module";
    rev = "v0.57";
    sha256 = "1q0f0zprcn0ypl2qh964cq186l3f40p0z7n7x22m8cxj367vf000";
  };

  lua-ext = fetchFromGitHub {
    owner = "openresty";
    repo = "lua-nginx-module";
    rev = "v0.9.15";
    sha256 = "0kicfs0gyfb5fhjmrwr6p09c5x6g0jwsh0wg5bsp3p209rnbq94q";
  };

  set-misc-ext = fetchFromGitHub {
    owner = "openresty";
    repo = "set-misc-nginx-module";
    rev = "v0.28";
    sha256 = "1vixj60q0liri7k5ax85grj7q9vvgybkx421bwphbhai5xrjip96";
  };

  fluentd = fetchFromGitHub {
    owner = "fluent";
    repo = "nginx-fluentd-module";
    rev = "8af234043059c857be27879bc547c141eafd5c13";
    sha256 = "1ycb5zd9sw60ra53jpak1m73zwrjikwhrrh9q6266h1mlyns7zxm";
  };

  develkit-ext = fetchFromGitHub {
    owner = "simpl";
    repo = "ngx_devel_kit";
    rev = "v0.2.19";
    sha256 = "1cqcasp4lc6yq5pihfcdw4vp4wicngvdc3nqg3bg52r63c1qrz76";
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
    "--with-select_module"
    "--with-poll_module"
    "--with-aio_module"
    "--with-threads"
    "--with-file-aio"
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
    ++ optional set_misc "--add-module=${set-misc-ext}"
    ++ optional (elem stdenv.system (with platforms; linux ++ freebsd)) "--with-file-aio"
    ++ optional fluent "--add-module=${fluentd}";


  additionalFlags = optionalString stdenv.isDarwin "-Wno-error=deprecated-declarations -Wno-error=conditional-uninitialized";

  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${libxml2}/include/libxml2 $additionalFlags"
  '';

  meta = {
    description = "A reverse proxy and lightweight webserver";
    homepage    = http://nginx.org;
    license     = licenses.bsd2;
    platforms   = platforms.all;
    maintainers = with maintainers; [ thoughtpolice raskin ];
  };
}
