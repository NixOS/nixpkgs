{ stdenv, fetchurl, fetchgit, openssl, zlib, pcre, libxml2, libxslt, expat
, gd, geoip
, rtmp ? false
, fullWebDAV ? false
, syslog ? false
, moreheaders ? false
, echo ? false }:

with stdenv.lib;

let
  version = "1.6.0";
  mainSrc = fetchurl {
    url = "http://nginx.org/download/nginx-${version}.tar.gz";
    sha256 = "06pwmg4qyd1sirpyl47s6qp94qc8a36dlkaw5pgv7s63l5bxffll";
  };

  rtmp-ext = fetchgit {
    url = https://github.com/arut/nginx-rtmp-module.git;
    rev = "8c2229cce5d4d4574e8fb7b130281497f746f0fa";
    sha256 = "6caea2a13161345c3fc963679730be54cebebddf1406ac7d4ef4ce72ac0b90b0";
  };

  dav-ext = fetchgit {
    url = "https://github.com/arut/nginx-dav-ext-module";
    rev = "89d582d31ab624ff1c6a4cec0c1a52839507b323";
    sha256 = "2175f83a291347504770d2a4bb5069999e9f7408697bd49464b6b54e994493e1";
  };

  syslog-ext = fetchgit {
    url = https://github.com/yaoweibin/nginx_syslog_patch.git;
    rev = "3ca5ba65541637f74467038aa032e2586321d0cb";
    sha256 = "15z9r17lx42fdcw8lalddc86wpabgmc1rqi7f90v4mcirjzrpgyi";
  };

  moreheaders-ext = fetchgit {
    url = https://github.com/openresty/headers-more-nginx-module.git;
    rev = "0c6e05d3125a97892a250e9ba8b7674163ba500b";
    sha256 = "e121d97fd3c81c64e6cbf6902bbcbdb01be9ac985c6832d40434379d5e998eaf";
  };

  echo-ext = fetchgit {
    url = https://github.com/openresty/echo-nginx-module.git;
    rev = "refs/tags/v0.53";
    sha256 = "90d4e3a49c678019f4f335bc18529aa108fcc9cfe0747ea4e2f6084a70da2868";
  };
in

stdenv.mkDerivation rec {
  name = "nginx-${version}";
  src = mainSrc;

  buildInputs =
    [ openssl zlib pcre libxml2 libxslt gd geoip
    ] ++ optional fullWebDAV expat;

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
