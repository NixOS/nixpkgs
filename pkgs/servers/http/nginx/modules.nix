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
, ffmpeg
, geoip
, libbsd
, libiconv
, libmaxminddb
, libmodsecurity
, libuuid
, libxml2
, lmdb
, luajit
, msgpuck
, openssl
, opentracing-cpp
, pam
, psol
, which
, yajl
, zlib
}:

let

  http_proxy_connect_module_generic = patchName: rec {
    name = "http_proxy_connect";
    src = fetchFromGitHub {
      name = "http_proxy_connect_module_generic";
      owner = "chobits";
      repo = "ngx_http_proxy_connect_module";
      rev = "96ae4e06381f821218f368ad0ba964f87cbe0266";
      sha256 = "1nc7z31i7x9dzp67kzgvs34hs6ps749y26wcpi3wf5mm63i803rh";
    };
    patches = [
      "${src}/patch/${patchName}.patch"
    ];
  };

in

let self = {
  fastcgi-cache-purge = throw "fastcgi-cache-purge was renamed to cache-purge";
  ngx_aws_auth = throw "ngx_aws_auth was renamed to aws-auth";

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
    meta = {
      maintainers = with lib.maintainers; [ aneeshusa ];
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

    meta = {
      maintainers = with lib.maintainers; [ pinpox ];
    };
  };

  http_proxy_connect_module_v18 = http_proxy_connect_module_generic "proxy_connect_rewrite_1018" // {
    supports = with lib.versions; version: major version == "1" && minor version == "18";
  };

  http_proxy_connect_module_v19 = http_proxy_connect_module_generic "proxy_connect_rewrite_1018" // {
    supports = with lib.versions; version: major version == "1" && minor version == "19";
  };

  ipscrub = {
    name = "ipscrub";
    src = fetchFromGitHub
      {
        name = "ipscrub";
        owner = "masonicboom";
        repo = "ipscrub";
        rev = "v1.0.1";
        sha256 = "0qcx15c8wbsmyz2hkmyy5yd7qn1n84kx9amaxnfxkpqi05vzm1zz";
      } + "/ipscrub";
    inputs = [ libbsd ];
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
    inputs = [ luajit ];
    preConfigure = let
      # fix compilation against nginx 1.23.0
      nginx-1-23-patch = fetchpatch {
        url = "https://github.com/openresty/lua-nginx-module/commit/b6d167cf1a93c0c885c28db5a439f2404874cb26.patch";
        sha256 = "sha256-l7GHFNZXg+RG2SIBjYJO1JHdGUtthWnzLIqEORJUNr4=";
      };
    in ''
      export LUAJIT_LIB="${luajit}/lib"
      export LUAJIT_INC="$(realpath ${luajit}/include/luajit-*)"

      # make source directory writable to allow generating src/ngx_http_lua_autoconf.h
      lua_src=$TMPDIR/lua-src
      cp -r "${src}/" "$lua_src"
      chmod -R +w "$lua_src"
      patch -p1 -d $lua_src -i ${nginx-1-23-patch}
      export configureFlags="''${configureFlags//"${src}"/"$lua_src"}"
      unset lua_src
    '';
    allowMemoryWriteExecute = true;
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
    inputs = [ luajit ];
    allowMemoryWriteExecute = true;
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
  };

  moreheaders = {
    name = "moreheaders";
    src = fetchFromGitHub {
      name = "moreheaders";
      owner = "openresty";
      repo = "headers-more-nginx-module";
      rev = "v0.34";
      sha256 = "sha256-LsrN/rF/p17x/80Jw9CgbmK69to6LycCM1OwTBojz8M=";
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
  };

  njs = rec {
    name = "njs";
    src = fetchhg {
      url = "https://hg.nginx.org/njs";
      rev = "0.7.10";
      sha256 = "sha256-/yKzY+BUFxLk8bWo+mqKfRVRsC2moe+WvhaRYIGdr6Y=";
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
  };

  pagespeed = {
    name = "pagespeed";
    src = let
      moduleSrc = fetchFromGitHub {
        name = "pagespeed";
        owner = "pagespeed";
        repo = "ngx_pagespeed";
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
  };

  secure-token = {
    name = "secure-token";
    src = fetchFromGitHub {
      name = "secure-token";
      owner = "kaltura";
      repo = "nginx-secure-token-module";
      rev = "95bdc0d1aca06ea7fe42555f71e65910bd74914d";
      sha256 = "19wzck1xzq4kz7nyabcwzlank1k7wi7w2wn2c1mwz374c79g8ggp";
    };
    inputs = [ openssl ];
  };

  set-misc = {
    name = "set-misc";
    src = fetchFromGitHub {
      name = "set-misc";
      owner = "openresty";
      repo = "set-misc-nginx-module";
      rev = "v0.32";
      sha256 = "048a6jwinbjgxiprjj9ml3fdp0mhkx89g6ggams57fsx9m5vaxax";
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
  };

  video-thumbextractor = {
    name = "video-thumbextractor";
    src = fetchFromGitHub {
      name = "video-thumbextractor";
      owner = "wandenberg";
      repo = "nginx-video-thumbextractor-module";
      rev = "92b80642538eec4cfc98114dec5917b8d820e912";
      sha256 = "0a8d9ifryhhnll7k7jcsf9frshk5yhpsgz7zgxdmw81wbz5hxklc";
    };
    inputs = [ ffmpeg ];
  };

  vod = {
    name = "vod";
    src = fetchFromGitHub {
      name = "vod";
      owner = "kaltura";
      repo = "nginx-vod-module";
      rev = "1.29";
      sha256 = "1z0ka0cwqbgh3fv2d5yva395sf90626rdzx7lyfrgs89gy4h9nrr";
    };
    inputs = [ ffmpeg fdk_aac openssl libxml2 libiconv ];
  };

  vts = {
    name = "vts";
    src = fetchFromGitHub {
      name = "vts";
      owner = "vozlt";
      repo = "nginx-module-vts";
      rev = "v0.2.1";
      sha256 = "sha256-x4ry5ljPeJQY+7Mp04/xYIGf22d6Nee7CSqHezdK4gQ=";
    };
  };
}; in self // lib.optionalAttrs config.allowAliases {
  # deprecated or renamed packages
  modsecurity-nginx = self.modsecurity;
}
