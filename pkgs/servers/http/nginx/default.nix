{ stdenv, fetchurl, fetchgit, openssl, zlib, pcre, libxml2, libxslt, expat
, gd, geoip
, rtmp ? false
, fullWebDAV ? false
, syslog ? false
, moreheaders ? false}:

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
in

stdenv.mkDerivation rec {
  name = "nginx-${version}";
  src = mainSrc;

  buildInputs =
    [ openssl zlib pcre libxml2 libxslt gd geoip
    ] ++ stdenv.lib.optional fullWebDAV expat;

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
  ] ++ stdenv.lib.optional rtmp "--add-module=${rtmp-ext}"
    ++ stdenv.lib.optional fullWebDAV "--add-module=${dav-ext}"
    ++ stdenv.lib.optional syslog "--add-module=${syslog-ext}"
    ++ stdenv.lib.optional moreheaders "--add-module=${moreheaders-ext}";

  additionalFlags = stdenv.lib.optionalString stdenv.isDarwin "-Wno-error=deprecated-declarations";

  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${libxml2}/include/libxml2 $additionalFlags"
  '';

  postInstall = ''
    mv $out/sbin $out/bin
  '';

  meta = {
    description = "A reverse proxy and lightweight webserver";
    homepage    = http://nginx.org;
    license     = stdenv.lib.licenses.bsd2;
    platforms   = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice raskin ];
  };
}
