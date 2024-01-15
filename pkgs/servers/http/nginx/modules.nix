{ lib
, config
, fetchFromGitHub
, fetchFromGitLab
, fetchhg
, fetchpatch
, runCommand

, arpa2common
, brotli
, curl
, expat
, fdk_aac
, ffmpeg-headless
, geoip
, libbsd
, libiconv
, libjpeg
, libkrb5
, libmaxminddb
, libmodsecurity
, libuuid
, libxml2
, lmdb
, luajit_openresty
, msgpuck
, openssl
, opentracing-cpp
, pam
, psol
, which
, yajl
, zlib
, zstd
}:

let

  http_proxy_connect_module_generic = patchName: rec {
    name = "http_proxy_connect";
    src = fetchFromGitHub {
      name = "http_proxy_connect_module_generic";
      owner = "chobits";
      repo = "ngx_http_proxy_connect_module";
      # 2023-06-19
      rev = "dcb9a2c614d376b820d774db510d4da12dfe1e5b";
      hash = "sha256-AzMhTSzmk3osSYy2q28/hko1v2AOTnY/dP5IprqGlQo=";
    };

    patches = [
      "${src}/patch/${patchName}.patch"
    ];

    meta = with lib; {
      description = "Forward proxy module for CONNECT request handling";
      homepage = "https://github.com/chobits/ngx_http_proxy_connect_module";
      license = with licenses; [ bsd2 ];
      maintainers = with maintainers; [ ];
    };
  };

in

let self = {
  akamai-token-validate = {
    name = "akamai-token-validate";
    src = fetchFromGitHub {
      name = "akamai-token-validate";
      owner = "kaltura";
      repo = "nginx-akamai-token-validate-module";
      rev = "34fd0c94d2c43c642f323491c4f4a226cd83b962";
      sha256 = "0yf34s11vgkcl03wbl6gjngm3p9hs8vvm7hkjkwhjh39vkk2a7cy";
    };

    inputs = [ openssl ];

    meta = with lib; {
      description = "Validates Akamai v2 query string tokens";
      homepage = "https://github.com/kaltura/nginx-akamai-token-validate-module";
      license = with licenses; [ agpl3 ];
      maintainers = with maintainers; [ ];
    };
  };

  auth-a2aclr = {
    name = "auth-a2aclr";
    src = fetchFromGitLab {
      name = "auth-a2aclr";
      owner = "arpa2";
      repo = "nginx-auth-a2aclr";
      rev = "bbabf9480bb2b40ac581551883a18dfa6522dd63";
      sha256 = "sha256-h2LgMhreCgod+H/bNQzY9BvqG9ezkwikwWB3T6gHH04=";
    };

    inputs = [
      (arpa2common.overrideAttrs
        (old: rec {
          version = "0.7.1";

          src = fetchFromGitLab {
            owner = "arpa2";
            repo = "arpa2common";
            rev = "v${version}";
            sha256 = "sha256-8zVsAlGtmya9EK4OkGUMu2FKJRn2Q3bg2QWGjqcii64=";
          };
        }))
    ];

    meta = with lib; {
      description = "Integrate ARPA2 Resource ACLs into nginx";
      homepage = "https://gitlab.com/arpa2/nginx-auth-a2aclr";
      license = with licenses; [ isc ];
      maintainers = with maintainers; [ ];
    };
  };

  aws-auth = {
    name = "aws-auth";
    src = fetchFromGitHub {
      name = "aws-auth";
      owner = "anomalizer";
      repo = "ngx_aws_auth";
      rev = "2.1.1";
      sha256 = "10z67g40w7wpd13fwxyknkbg3p6hn61i4v8xw6lh27br29v1y6h9";
    };

    meta = with lib; {
      description = "Proxy to authenticated AWS services";
      homepage = "https://github.com/anomalizer/ngx_aws_auth";
      license = with licenses; [ bsd2 ];
      maintainers = with maintainers; [ ];
    };
  };

  brotli = {
    name = "brotli";
    src = let src' = fetchFromGitHub {
      name = "brotli";
      owner = "google";
      repo = "ngx_brotli";
      rev = "6e975bcb015f62e1f303054897783355e2a877dc";
      sha256 = "sha256-G0IDYlvaQzzJ6cNTSGbfuOuSXFp3RsEwIJLGapTbDgo=";
    }; in
      runCommand "brotli" { } ''
        cp -a ${src'} $out
        substituteInPlace $out/filter/config \
          --replace '$ngx_addon_dir/deps/brotli/c' ${lib.getDev brotli}
      '';

    inputs = [ brotli ];

    meta = with lib; {
      description = "Brotli compression";
      homepage = "https://github.com/google/ngx_brotli";
      license = with licenses; [ bsd2 ];
      maintainers = with maintainers; [ ];
    };
  };

  cache-purge = {
    name = "cache-purge";
    src = fetchFromGitHub {
      name = "cache-purge";
      owner = "nginx-modules";
      repo = "ngx_cache_purge";
      rev = "2.5.1";
      sha256 = "0va4jz36mxj76nmq05n3fgnpdad30cslg7c10vnlhdmmic9vqncd";
    };

    meta = with lib; {
      description = "Adds ability to purge content from FastCGI, proxy, SCGI and uWSGI caches";
      homepage = "https://github.com/nginx-modules/ngx_cache_purge";
      license = with licenses; [ bsd2 ];
      maintainers = with maintainers; [ ];
    };
  };

  coolkit = {
    name = "coolkit";
    src = fetchFromGitHub {
      name = "coolkit";
      owner = "FRiCKLE";
      repo = "ngx_coolkit";
      rev = "0.2";
      sha256 = "1idj0cqmfsdqawjcqpr1fsq670fdki51ksqk2lslfpcs3yrfjpqh";
    };

    meta = with lib; {
      description = "Collection of small and useful nginx add-ons";
      homepage = "https://github.com/FRiCKLE/ngx_coolkit";
      license = with licenses; [ bsd2 ];
      maintainers = with maintainers; [ ];
    };
  };

  dav = {
    name = "dav";
    src = fetchFromGitHub {
      name = "dav";
      owner = "arut";
      repo = "nginx-dav-ext-module";
      rev = "v3.0.0";
      sha256 = "000dm5zk0m1hm1iq60aff5r6y8xmqd7djrwhgnz9ig01xyhnjv9w";
    };

    inputs = [ expat ];

    meta = with lib; {
      description = "WebDAV PROPFIND,OPTIONS,LOCK,UNLOCK support";
      homepage = "https://github.com/arut/nginx-dav-ext-module";
      license = with licenses; [ bsd2 ];
      maintainers = with maintainers; [ ];
    };
  };

  develkit = {
    name = "develkit";
    src = fetchFromGitHub {
      name = "develkit";
      owner = "vision5";
      repo = "ngx_devel_kit";
      rev = "v0.3.1";
      sha256 = "1c5zfpvm0hrd9lp8rasmw79dnr2aabh0i6y11wzb783bp8m3p2sq";
    };

    meta = with lib; {
      description = "Adds additional generic tools that module developers can use in their own modules";
      homepage = "https://github.com/vision5/ngx_devel_kit";
      license = with licenses; [ bsd3 ];
      maintainers = with maintainers; [ ];
    };
  };

  echo = {
    name = "echo";
    src = fetchFromGitHub {
      name = "echo";
      owner = "openresty";
      repo = "echo-nginx-module";
      rev = "v0.62";
      sha256 = "0kr1y094yw1a9fyrf4w73ikq18w5ys463wza9n7yfl77xdwirnvl";
    };

    meta = with lib; {
      description = "Brings echo, sleep, time, exec and more shell-style goodies to Nginx";
      homepage = "https://github.com/openresty/echo-nginx-module";
      license = with licenses; [ bsd2 ];
      maintainers = with maintainers; [ ];
    };
  };

  fancyindex = {
    name = "fancyindex";
    src = fetchFromGitHub {
      name = "fancyindex";
      owner = "aperezdc";
      repo = "ngx-fancyindex";
      rev = "v0.5.2";
      sha256 = "0nar45lp3jays3p6b01a78a6gwh6v0snpzcncgiphcqmj5kw8ipg";
    };

    meta = with lib; {
      description = " Fancy indexes module";
      homepage = "https://github.com/aperezdc/ngx-fancyindex";
      license = with licenses; [ bsd2 ];
      maintainers = with maintainers; [ aneeshusa ];
    };
  };

  fluentd = {
    name = "fluentd";
    src = fetchFromGitHub {
      name = "fluentd";
      owner = "fluent";
      repo = "nginx-fluentd-module";
      rev = "8af234043059c857be27879bc547c141eafd5c13";
      sha256 = "1ycb5zd9sw60ra53jpak1m73zwrjikwhrrh9q6266h1mlyns7zxm";
    };

    meta = with lib; {
      description = "Fluentd data collector";
      homepage = "https://github.com/fluent/nginx-fluentd-module";
      license = with licenses; [ asl20 ];
      maintainers = with maintainers; [ ];
    };
  };

  geoip2 = {
    name = "geoip2";
    src = fetchFromGitHub {
      name = "geoip2";
      owner = "leev";
      repo = "ngx_http_geoip2_module";
      rev = "3.4";
      sha256 = "CAs1JZsHY7RymSBYbumC2BENsXtZP3p4ljH5QKwz5yg=";
    };

    inputs = [ libmaxminddb ];

    meta = with lib; {
      description = "Creates variables with values from the maxmind geoip2 databases";
      homepage = "https://github.com/leev/ngx_http_geoip2_module";
      license = with licenses; [ bsd2 ];
      maintainers = with maintainers; [ pinpox ];
    };
  };

  http_proxy_connect_module_v24 = http_proxy_connect_module_generic "proxy_connect_rewrite_102101" // {
    supports = with lib.versions; version: major version == "1" && minor version == "24";
  };

  http_proxy_connect_module_v25 = http_proxy_connect_module_generic "proxy_connect_rewrite_102101" // {
    supports = with lib.versions; version: major version == "1" && minor version == "25";
  };

  ipscrub = {
    name = "ipscrub";
    src = fetchFromGitHub {
      name = "ipscrub";
      owner = "masonicboom";
      repo = "ipscrub";
      rev = "v1.0.1";
      sha256 = "0qcx15c8wbsmyz2hkmyy5yd7qn1n84kx9amaxnfxkpqi05vzm1zz";
    } + "/ipscrub";

    inputs = [ libbsd ];

    meta = with lib; {
      description = " IP address anonymizer";
      homepage = "https://github.com/masonicboom/ipscrub";
      license = with licenses; [ bsd3 ];
      maintainers = with maintainers; [ ];
    };
  };

  limit-speed = {
    name = "limit-speed";
    src = fetchFromGitHub {
      name = "limit-speed";
      owner = "yaoweibin";
      repo = "nginx_limit_speed_module";
      rev = "f77ad4a56fbb134878e75827b40cf801990ed936";
      sha256 = "0kkrd08zpcwx938i2is07vq6pgjkvn97xzjab0g4zaz8bivgmjp8";
    };

    meta = with lib; {
      description = "Limit the total speed from the specific user";
      homepage = "https://github.com/yaoweibin/nginx_limit_speed_module";
      license = with licenses; [ bsd2 ];
      maintainers = with maintainers; [ ];
    };
  };

  live = {
    name = "live";
    src = fetchFromGitHub {
      name = "live";
      owner = "arut";
      repo = "nginx-live-module";
      rev = "5e4a1e3a718e65e5206c24eba00d42b0d1c4b7dd";
      sha256 = "1kpnhl4b50zim84z22ahqxyxfq4jv8ab85kzsy2n5ciqbyg491lz";
    };

    meta = with lib; {
      description = "HTTP live module";
      homepage = "https://github.com/arut/nginx-live-module";
      license = with licenses; [ bsd2 ];
      maintainers = with maintainers; [ ];
    };
  };

  lua = rec {
    name = "lua";
    src = fetchFromGitHub {
      name = "lua";
      owner = "openresty";
      repo = "lua-nginx-module";
      rev = "v0.10.22";
      sha256 = "sha256-TyeTL7/0dI2wS2eACS4sI+9tu7UpDq09aemMaklkUss=";
    };

    inputs = [ luajit_openresty ];

    preConfigure = let
      # fix compilation against nginx 1.23.0
      nginx-1-23-patch = fetchpatch {
        url = "https://github.com/openresty/lua-nginx-module/commit/b6d167cf1a93c0c885c28db5a439f2404874cb26.patch";
        sha256 = "sha256-l7GHFNZXg+RG2SIBjYJO1JHdGUtthWnzLIqEORJUNr4=";
      };
    in ''
      export LUAJIT_LIB="${luajit_openresty}/lib"
      export LUAJIT_INC="$(realpath ${luajit_openresty}/include/luajit-*)"

      # make source directory writable to allow generating src/ngx_http_lua_autoconf.h
      lua_src=$TMPDIR/lua-src
      cp -r "${src}/" "$lua_src"
      chmod -R +w "$lua_src"
      patch -p1 -d $lua_src -i ${nginx-1-23-patch}
      export configureFlags="''${configureFlags//"${src}"/"$lua_src"}"
      unset lua_src
    '';

    allowMemoryWriteExecute = true;

    meta = with lib; {
      description = "Embed the Power of Lua";
      homepage = "https://github.com/openresty/lua-nginx-module";
      license = with licenses; [ bsd2 ];
      maintainers = with maintainers; [ ];
    };
  };

  lua-upstream = {
    name = "lua-upstream";
    src = fetchFromGitHub {
      name = "lua-upstream";
      owner = "openresty";
      repo = "lua-upstream-nginx-module";
      rev = "v0.07";
      sha256 = "1gqccg8airli3i9103zv1zfwbjm27h235qjabfbfqk503rjamkpk";
    };

    inputs = [ luajit_openresty ];
    allowMemoryWriteExecute = true;

    meta = with lib; {
      description = "Expose Lua API to ngx_lua for Nginx upstreams";
      homepage = "https://github.com/openresty/lua-upstream-nginx-module";
      license = with licenses; [ bsd2 ];
      maintainers = with maintainers; [ ];
    };
  };

  modsecurity = {
    name = "modsecurity";
    src = fetchFromGitHub {
      name = "modsecurity-nginx";
      owner = "SpiderLabs";
      repo = "ModSecurity-nginx";
      rev = "v1.0.3";
      sha256 = "sha256-xp0/eqi5PJlzb9NaUbNnzEqNcxDPyjyNwZOwmlv1+ag=";
    };

    inputs = [ curl geoip libmodsecurity libxml2 lmdb yajl ];
    disableIPC = true;

    meta = with lib; {
      description = "Open source, cross platform web application firewall (WAF)";
      homepage = "https://github.com/SpiderLabs/ModSecurity";
      license = with licenses; [ asl20 ];
      maintainers = with maintainers; [ ];
    };
  };

  moreheaders = {
    name = "moreheaders";
    src = fetchFromGitHub {
      name = "moreheaders";
      owner = "openresty";
      repo = "headers-more-nginx-module";
      rev = "v0.36";
      sha256 = "sha256-X+ygIesQ9PGm5yM+u1BOLYVpm1172P8jWwXNr3ixFY4=";
    };

    meta = with lib; {
      description = "Set, add, and clear arbitrary output headers";
      homepage = "https://github.com/openresty/headers-more-nginx-module";
      license = with licenses; [ bsd2 ];
      maintainers = with maintainers; [ SuperSandro2000 ];
    };
  };

  mpeg-ts = {
    name = "mpeg-ts";
    src = fetchFromGitHub {
      name = "mpeg-ts";
      owner = "arut";
      repo = "nginx-ts-module";
      rev = "v0.1.1";
      sha256 = "12dxcyy6wna1fccl3a9lnsbymd6p4apnwz6c24w74v97qvpfdxqd";
    };

    meta = with lib; {
      description = "MPEG-TS Live Module";
      homepage = "https://github.com/arut/nginx-ts-module";
      license = with licenses; [ bsd2 ];
      maintainers = with maintainers; [ ];
    };
  };

  naxsi = {
    name = "naxsi";
    src = fetchFromGitHub {
      name = "naxsi";
      owner = "nbs-system";
      repo = "naxsi";
      rev = "95ac520eed2ea04098a76305fd0ad7e9158840b7";
      sha256 = "0b5pnqkgg18kbw5rf2ifiq7lsx5rqmpqsql6hx5ycxjzxj6acfb3";
    } + "/naxsi_src";

    meta = with lib; {
      description = "Open-source, high performance, low rules maintenance WAF";
      homepage = "https://github.com/nbs-system/naxsi";
      license = with licenses; [ gpl3 ];
      maintainers = with maintainers; [ ];
    };
  };

  njs = rec {
    name = "njs";
    src = fetchhg {
      url = "https://hg.nginx.org/njs";
      rev = "0.8.1";
      sha256 = "sha256-bFHrcA1ROMwYf+s0EWOXzkru6wvfRLvjvN8BV/r2tMc=";
      name = "nginx-njs";
    };

    # njs module sources have to be writable during nginx build, so we copy them
    # to a temporary directory and change the module path in the configureFlags
    preConfigure = ''
      NJS_SOURCE_DIR=$(readlink -m "$TMPDIR/${src}")
      mkdir -p "$(dirname "$NJS_SOURCE_DIR")"
      cp --recursive "${src}" "$NJS_SOURCE_DIR"
      chmod -R u+rwX,go+rX "$NJS_SOURCE_DIR"
      export configureFlags="''${configureFlags/"${src}"/"$NJS_SOURCE_DIR/nginx"}"
      unset NJS_SOURCE_DIR
    '';

    inputs = [ which ];

    meta = with lib; {
      description = "Subset of the JavaScript language that allows extending nginx functionality";
      homepage = "https://nginx.org/en/docs/njs/";
      license = with licenses; [ bsd2 ];
      maintainers = with maintainers; [ ];
    };
  };

  opentracing = {
    name = "opentracing";
    src =
      let src' = fetchFromGitHub {
        name = "opentracing";
        owner = "opentracing-contrib";
        repo = "nginx-opentracing";
        rev = "v0.10.0";
        sha256 = "1q234s3p55xv820207dnh4fcxkqikjcq5rs02ai31ylpmfsf0kkb";
      };
      in "${src'}/opentracing";

    inputs = [ opentracing-cpp ];

    meta = with lib; {
      description = "Enable requests served by nginx for distributed tracing via The OpenTracing Project";
      homepage = "https://github.com/opentracing-contrib/nginx-opentracing";
      license = with licenses; [ asl20 ];
      maintainers = with maintainers; [ ];
    };
  };

  pagespeed = {
    name = "pagespeed";
    src = let
      moduleSrc = fetchFromGitHub {
        name = "pagespeed";
        owner = "apache";
        repo = "incubator-pagespeed-ngx";
        rev = "v${psol.version}-stable";
        sha256 = "0ry7vmkb2bx0sspl1kgjlrzzz6lbz07313ks2lr80rrdm2zb16wp";
      };
    in runCommand "ngx_pagespeed" {
      meta = {
        description = "PageSpeed module for Nginx";
        homepage = "https://developers.google.com/speed/pagespeed/module/";
        license = lib.licenses.asl20;
      };
    } ''
      cp -r "${moduleSrc}" "$out"
      chmod -R +w "$out"
      ln -s "${psol}" "$out/psol"
    '';

    inputs = [ zlib libuuid ]; # psol deps
    allowMemoryWriteExecute = true;

    meta = with lib; {
      description = "Automatic PageSpeed optimization";
      homepage = "https://github.com/apache/incubator-pagespeed-ngx";
      license = with licenses; [ asl20 ];
      maintainers = with maintainers; [ ];
    };
  };

  pam = {
    name = "pam";
    src = fetchFromGitHub {
      name = "pam";
      owner = "sto";
      repo = "ngx_http_auth_pam_module";
      rev = "v1.5.3";
      sha256 = "sha256:09lnljdhjg65643bc4535z378lsn4llbq67zcxlln0pizk9y921a";
    };

    inputs = [ pam ];

    meta = with lib; {
      description = "Use PAM for simple http authentication ";
      homepage = "https://github.com/sto/ngx_http_auth_pam_module";
      license = with licenses; [ bsd2 ];
      maintainers = with maintainers; [ ];
    };
  };

  pinba = {
    name = "pinba";
    src = fetchFromGitHub {
      name = "pinba";
      owner = "tony2001";
      repo = "ngx_http_pinba_module";
      rev = "28131255d4797a7e2f82a6a35cf9fc03c4678fe6";
      sha256 = "00fii8bjvyipq6q47xhjhm3ylj4rhzmlk3qwxmfpdn37j7bc8p8c";
    };

    meta = with lib; {
      description = "Pinba module for nginx";
      homepage = "https://github.com/tony2001/ngx_http_pinba_module";
      license = with licenses; [ unfree ]; # no license in repo
      maintainers = with maintainers; [ ];
    };
  };

  push-stream = {
    name = "push-stream";
    src = fetchFromGitHub {
      name = "push-stream";
      owner = "wandenberg";
      repo = "nginx-push-stream-module";
      rev = "1cdc01521ed44dc614ebb5c0d19141cf047e1f90";
      sha256 = "0ijka32b37dl07k2jl48db5a32ix43jaczrpjih84cvq8yph0jjr";
    };

    meta = with lib; {
      description = "Pure stream http push technology";
      homepage = "https://github.com/wandenberg/nginx-push-stream-module";
      license = with licenses; [ gpl3 ];
      maintainers = with maintainers; [ ];
    };
  };

  rtmp = {
    name = "rtmp";
    src = fetchFromGitHub {
      name = "rtmp";
      owner = "arut";
      repo = "nginx-rtmp-module";
      rev = "v1.2.2";
      sha256 = "0y45bswk213yhkc2v1xca2rnsxrhx8v6azxz9pvi71vvxcggqv6h";
    };

    meta = with lib; {
      description = "Media Streaming Server";
      homepage = "https://github.com/arut/nginx-rtmp-module";
      license = with licenses; [ bsd2 ];
      maintainers = with maintainers; [ ];
    };
  };

  secure-token = rec {
    name = "secure-token";
    version = "1.5";
    src = fetchFromGitHub {
      name = "secure-token";
      owner = "kaltura";
      repo = "nginx-secure-token-module";
      rev = "refs/tags/${version}";
      hash = "sha256-qYTjGS9pykRqMFmNls52YKxEdXYhHw+18YC2zzdjEpU=";
    };

    inputs = [ openssl ];

    meta = with lib; {
      description = "Generates CDN tokens, either as a cookie or as a query string parameter";
      homepage = "https://github.com/kaltura/nginx-secure-token-module";
      license = with licenses; [ agpl3 ];
      maintainers = with maintainers; [ ];
    };
  };

  set-misc = {
    name = "set-misc";
    src = fetchFromGitHub {
      name = "set-misc";
      owner = "openresty";
      repo = "set-misc-nginx-module";
      rev = "v0.33";
      hash = "sha256-jMMj3Ki1uSfQzagoB/O4NarxPjiaF9YRwjSKo+cgMxo=";
    };

    meta = with lib; {
      description = "Various set_xxx directives added to the rewrite module (md5/sha1, sql/json quoting and many more)";
      homepage = "https://github.com/openresty/set-misc-nginx-module";
      license = with licenses; [ bsd2 ];
      maintainers = with maintainers; [ ];
    };
  };

  shibboleth = {
    name = "shibboleth";
    src = fetchFromGitHub {
      name = "shibboleth";
      owner = "nginx-shib";
      repo = "nginx-http-shibboleth";
      rev = "3f5ff4212fa12de23cb1acae8bf3a5a432b3f43b";
      sha256 = "136zjipaz7iikgcgqwdv1mrh3ya996zyzbkdy6d4k07s2h9g7hy6";
    };

    meta = with lib; {
      description = "Shibboleth auth request";
      homepage = "https://github.com/nginx-shib/nginx-http-shibboleth";
      license = with licenses; [ bsd2 ];
      maintainers = with maintainers; [ ];
    };
  };

  sla = {
    name = "sla";
    src = fetchFromGitHub {
      name = "sla";
      owner = "goldenclone";
      repo = "nginx-sla";
      rev = "7778f0125974befbc83751d0e1cadb2dcea57601";
      sha256 = "1x5hm6r0dkm02ffny8kjd7mmq8przyd9amg2qvy5700x6lb63pbs";
    };

    meta = with lib; {
      description = "Implements a collection of augmented statistics based on HTTP-codes and upstreams response time";
      homepage = "https://github.com/goldenclone/nginx-sla";
      license = with licenses; [ unfree ]; # no license in repo
      maintainers = with maintainers; [ ];
    };
  };

  slowfs-cache = {
    name = "slowfs-cache";
    src = fetchFromGitHub {
      name = "slowfs-cache";
      owner = "FRiCKLE";
      repo = "ngx_slowfs_cache";
      rev = "1.10";
      sha256 = "1gyza02pcws3zqm1phv3ag50db5gnapxyjwy8skjmvawz7p5bmxr";
    };

    meta = with lib; {
      description = "Adds ability to cache static files";
      homepage = "https://github.com/friCKLE/ngx_slowfs_cache";
      license = with licenses; [ bsd2 ];
      maintainers = with maintainers; [ ];
    };
  };

  sorted-querystring = {
    name = "sorted-querystring";
    src = fetchFromGitHub {
      name = "sorted-querystring";
      owner = "wandenberg";
      repo = "nginx-sorted-querystring-module";
      rev = "0.3";
      sha256 = "0p6b0hcws39n27fx4xp9k4hb3pcv7b6kah4qqaj0pzjy3nbp4gj7";
    };

    meta = with lib; {
      description = "Expose querystring parameters sorted in a variable";
      homepage = "https://github.com/wandenberg/nginx-sorted-querystring-module";
      license = with licenses; [ mit ];
      maintainers = with maintainers; [ ];
    };
  };

  spnego-http-auth = {
    name = "spnego-http-auth";
    src = fetchFromGitHub {
      name = "spnego-http-auth";
      owner = "stnoonan";
      repo = "spnego-http-auth-nginx-module";
      rev = "72c8ee04c81f929ec84d5a6d126f789b77781a8c";
      sha256 = "05rw3a7cv651951li995r5l1yzz6kwkm2xpbd59jsfzd74bw941i";
    };

    inputs = [ libkrb5 ];

    meta = with lib; {
      description = "SPNEGO HTTP Authentication Module";
      homepage = "https://github.com/stnoonan/spnego-http-auth-nginx-module";
      license = with licenses; [ bsd2 ];
      maintainers = with maintainers; [ ];
    };
  };

  statsd = {
    name = "statsd";
    src = fetchFromGitHub {
      name = "statsd";
      owner = "harvesthq";
      repo = "nginx-statsd";
      rev = "b970e40467a624ba710c9a5106879a0554413d15";
      sha256 = "1x8j4i1i2ahrr7qvz03vkldgdjdxi6mx75mzkfizfcc8smr4salr";
    };

    meta = with lib; {
      description = "Send statistics to statsd";
      homepage = "https://github.com/harvesthq/nginx-statsd";
      license = with licenses; [ bsd3 ];
      maintainers = with maintainers; [ ];
    };
  };

  stream-sts = {
    name = "stream-sts";
    src = fetchFromGitHub {
      name = "stream-sts";
      owner = "vozlt";
      repo = "nginx-module-stream-sts";
      rev = "v0.1.1";
      sha256 = "1jdj1kik6l3rl9nyx61xkqk7hmqbncy0rrqjz3dmjqsz92y8zaya";
    };

    meta = with lib; {
      description = "Stream server traffic status core module";
      homepage = "https://github.com/vozlt/nginx-module-stream-sts";
      license = with licenses; [ bsd2 ];
      maintainers = with maintainers; [ ];
    };
  };

  sts = {
    name = "sts";
    src = fetchFromGitHub {
      name = "sts";
      owner = "vozlt";
      repo = "nginx-module-sts";
      rev = "v0.1.1";
      sha256 = "0nvb29641x1i7mdbydcny4qwlvdpws38xscxirajd2x7nnfdflrk";
    };

    meta = with lib; {
      description = "Stream server traffic status module";
      homepage = "https://github.com/vozlt/nginx-module-sts";
      license = with licenses; [ bsd2 ];
      maintainers = with maintainers; [ ];
    };
  };

  subsFilter = {
    name = "subsFilter";
    src = fetchFromGitHub {
      name = "subsFilter";
      owner = "yaoweibin";
      repo = "ngx_http_substitutions_filter_module";
      rev = "b8a71eacc7f986ba091282ab8b1bbbc6ae1807e0";
      sha256 = "027jxzx66q9a6ycn47imjh40xmnqr0z423lz0ds3w4rf1c2x130f";
    };

    meta = with lib; {
      description = "Filter module which can do both regular expression and fixed string substitutions";
      homepage = "https://github.com/yaoweibin/ngx_http_substitutions_filter_module";
      license = with licenses; [ bsd2 ];
      maintainers = with maintainers; [ ];
    };
  };

  sysguard = {
    name = "sysguard";
    src = fetchFromGitHub {
      name = "sysguard";
      owner = "vozlt";
      repo = "nginx-module-sysguard";
      rev = "e512897f5aba4f79ccaeeebb51138f1704a58608";
      sha256 = "19c6w6wscbq9phnx7vzbdf4ay6p2ys0g7kp2rmc9d4fb53phrhfx";
    };

    meta = with lib; {
      description = "Nginx sysguard module";
      homepage = "https://github.com/vozlt/nginx-module-sysguard";
      license = with licenses; [ bsd2 ];
      maintainers = with maintainers; [ ];
    };
  };

  upload = {
    name = "upload";
    src = fetchFromGitHub {
      name = "upload";
      owner = "fdintino";
      repo = "nginx-upload-module";
      rev = "2.3.0";
      sha256 = "8veZP516oC7TESO368ZsZreetbDt+1eTcamk7P1kWjU=";
    };

    meta = with lib; {
      description = "Handle file uploads using multipart/form-data encoding and resumable uploads";
      homepage = "https://github.com/fdintino/nginx-upload-module";
      license = with licenses; [ bsd3 ];
      maintainers = with maintainers; [ ];
    };
  };

  upstream-check = {
    name = "upstream-check";
    src = fetchFromGitHub {
      name = "upstream-check";
      owner = "yaoweibin";
      repo = "nginx_upstream_check_module";
      rev = "e538034b6ad7992080d2403d6d3da56e4f7ac01e";
      sha256 = "06y7k04072xzqyqyb08m0vaaizkp4rfwm0q7i735imbzw2rxb74l";
    };

    meta = with lib; {
      description = "Support upstream health check";
      homepage = "https://github.com/yaoweibin/nginx_upstream_check_module";
      license = with licenses; [ bsd2 ];
      maintainers = with maintainers; [ ];
    };
  };

  upstream-tarantool = {
    name = "upstream-tarantool";
    src = fetchFromGitHub {
      name = "upstream-tarantool";
      owner = "tarantool";
      repo = "nginx_upstream_module";
      rev = "v2.7.1";
      sha256 = "0ya4330in7zjzqw57djv4icpk0n1j98nvf0f8v296yi9rjy054br";
    };

    inputs = [ msgpuck.dev yajl ];

    meta = with lib; {
      description = "Tarantool NginX upstream module (REST, JSON API, websockets, load balancing)";
      homepage = "https://github.com/tarantool/nginx_upstream_module";
      license = with licenses; [ bsd2 ];
      maintainers = with maintainers; [ ];
    };
  };

  url = {
    name = "url";
    src = fetchFromGitHub {
      name = "url";
      owner = "vozlt";
      repo = "nginx-module-url";
      rev = "9299816ca6bc395625c3683fbd2aa7b916bfe91e";
      sha256 = "0mk1gjmfnry6hgdsnlavww9bn7223idw50jlkhh5k00q5509w4ip";
    };

    meta = with lib; {
      description = "URL encoding converting module";
      homepage = "https://github.com/vozlt/nginx-module-url";
      license = with licenses; [ bsd2 ];
      maintainers = with maintainers; [ ];
    };
  };

  video-thumbextractor = rec {
    name = "video-thumbextractor";
    version = "1.0.0";
    src = fetchFromGitHub {
      name = "video-thumbextractor";
      owner = "wandenberg";
      repo = "nginx-video-thumbextractor-module";
      rev = "refs/tags/${version}";
      hash = "sha256-F2cuzCbJdGYX0Zmz9MSXTB7x8+FBR6pPpXtLlDRCcj8=";
    };

    inputs = [ ffmpeg-headless libjpeg ];

    meta = with lib; {
      description = "Extract thumbs from a video file";
      homepage = "https://github.com/wandenberg/nginx-video-thumbextractor-module";
      license = with licenses; [ gpl3 ];
      maintainers = with maintainers; [ ];
    };
  };

  vod = {
    name = "vod";
    src = fetchFromGitHub {
      name = "vod";
      owner = "kaltura";
      repo = "nginx-vod-module";
      rev = "1.32";
      hash = "sha256-ZpG0oj60D3o7/7uyE8AybCiOtncVe1Jnjaz22sIFypk=";
      postFetch = ''
        substituteInPlace $out/vod/media_set.h \
          --replace "MAX_CLIPS (128)" "MAX_CLIPS (1024)"
      '';
    };

    inputs = [ ffmpeg-headless fdk_aac openssl libxml2 libiconv ];

    meta = with lib; {
      description = "VOD packager";
      homepage = "https://github.com/kaltura/nginx-vod-module";
      license = with licenses; [ agpl3 ];
      maintainers = with maintainers; [ ];
    };
  };

  vts = {
    name = "vts";
    src = fetchFromGitHub {
      name = "vts";
      owner = "vozlt";
      repo = "nginx-module-vts";
      rev = "v0.2.2";
      sha256 = "sha256-ReTmYGVSOwtnYDMkQDMWwxw09vT4iHYfYZvgd8iBotk=";
    };

    meta = with lib; {
      description = "Virtual host traffic status module";
      homepage = "https://github.com/vozlt/nginx-module-vts";
      license = with licenses; [ bsd2 ];
      maintainers = with maintainers; [ SuperSandro2000 ];
    };
  };

  zstd = {
    name = "zstd";
    src = fetchFromGitHub {
      name = "zstd";
      owner = "tokers";
      repo = "zstd-nginx-module";
      rev = "0.1.1";
      hash = "sha256-1gCV7uUsuYnZfb9e8VfjWkUloVINOUH5qzeJ03kIHgs=";
    };

    inputs = [ zstd ];

    meta = with lib; {
      description = "Nginx modules for the Zstandard compression";
      homepage = "https://github.com/tokers/zstd-nginx-module";
      license = with licenses; [ bsd2 ];
      maintainers = with maintainers; [ SuperSandro2000 ];
    };
  };
}; in self // lib.optionalAttrs config.allowAliases {
  # deprecated or renamed packages
  modsecurity-nginx = self.modsecurity;
  fastcgi-cache-purge = throw "fastcgi-cache-purge was renamed to cache-purge";
  ngx_aws_auth = throw "ngx_aws_auth was renamed to aws-auth";
}
