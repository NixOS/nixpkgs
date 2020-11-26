{ fetchFromGitHub, lib, pkgs }:

let

  http_proxy_connect_module_generic = patchName: rec {
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

{
  fastcgi-cache-purge = throw "fastcgi-cache-purge was renamed to cache-purge";
  ngx_aws_auth = throw "fastcgi-cache-purge was renamed to aws-auth";

  aws-auth = {
    src = fetchFromGitHub {
      name = "aws-auth";
      owner = "anomalizer";
      repo = "ngx_aws_auth";
      rev = "2.1.1";
      sha256 = "10z67g40w7wpd13fwxyknkbg3p6hn61i4v8xw6lh27br29v1y6h9";
    };
  };

  brotli = {
    src = let gitsrc = pkgs.fetchFromGitHub {
      name = "brotli";
      owner = "google";
      repo = "ngx_brotli";
      rev = "25f86f0bac1101b6512135eac5f93c49c63609e3";
      sha256 = "02hfvfa6milj40qc2ikpb9f95sxqvxk4hly3x74kqhysbdi06hhv";
    }; in pkgs.runCommandNoCC "ngx_brotli-src" {} ''
      cp -a ${gitsrc} $out
      substituteInPlace $out/filter/config \
        --replace '$ngx_addon_dir/deps/brotli/c' ${lib.getDev pkgs.brotli}
    '';
    inputs = [ pkgs.brotli ];
  };

  cache-purge = {
    src = fetchFromGitHub {
      name = "cache-purge";
      owner  = "nginx-modules";
      repo   = "ngx_cache_purge";
      rev    = "2.5.1";
      sha256 = "0va4jz36mxj76nmq05n3fgnpdad30cslg7c10vnlhdmmic9vqncd";
    };
  };

  coolkit = {
    src = fetchFromGitHub {
      name = "coolkit";
      owner  = "FRiCKLE";
      repo   = "ngx_coolkit";
      rev    = "0.2";
      sha256 = "1idj0cqmfsdqawjcqpr1fsq670fdki51ksqk2lslfpcs3yrfjpqh";
    };
  };

  dav = {
    src = fetchFromGitHub {
      name = "dav";
      owner = "arut";
      repo = "nginx-dav-ext-module";
      rev = "v3.0.0";
      sha256 = "000dm5zk0m1hm1iq60aff5r6y8xmqd7djrwhgnz9ig01xyhnjv9w";
    };
    inputs = [ pkgs.expat ];
  };

  develkit = {
    src = fetchFromGitHub {
      name = "develkit";
      owner = "vision5";
      repo = "ngx_devel_kit";
      rev = "v0.3.1";
      sha256 = "1c5zfpvm0hrd9lp8rasmw79dnr2aabh0i6y11wzb783bp8m3p2sq";
    };
  };

  echo = {
    src = fetchFromGitHub {
      name = "echo";
      owner = "openresty";
      repo = "echo-nginx-module";
      rev = "v0.62";
      sha256 = "0kr1y094yw1a9fyrf4w73ikq18w5ys463wza9n7yfl77xdwirnvl";
    };
  };

  fancyindex = {
    src = fetchFromGitHub {
      name = "fancyindex";
      owner = "aperezdc";
      repo = "ngx-fancyindex";
      rev = "v0.4.4";
      sha256 = "14xmzcl608pr7hb7wng6hpz7by51cfnxlszbka3zhp3kk86ljsi6";
    };
  };

  fluentd = {
    src = fetchFromGitHub {
      name = "fluentd";
      owner = "fluent";
      repo = "nginx-fluentd-module";
      rev = "8af234043059c857be27879bc547c141eafd5c13";
      sha256 = "1ycb5zd9sw60ra53jpak1m73zwrjikwhrrh9q6266h1mlyns7zxm";
    };
  };

  http_proxy_connect_module_v18 = http_proxy_connect_module_generic "proxy_connect_rewrite_1018" // {
    supports = with lib.versions; version: major version == "1" && minor version == "18";
  };

  http_proxy_connect_module_v19 = http_proxy_connect_module_generic "proxy_connect_rewrite_1018" // {
    supports = with lib.versions; version: major version == "1" && minor version == "19";
  };

  ipscrub = {
    src = fetchFromGitHub {
      name = "ipscrub";
      owner = "masonicboom";
      repo = "ipscrub";
      rev = "v1.0.1";
      sha256 = "0qcx15c8wbsmyz2hkmyy5yd7qn1n84kx9amaxnfxkpqi05vzm1zz";
    } + "/ipscrub";
    inputs = [ pkgs.libbsd ];
  };

  limit-speed = {
    src = fetchFromGitHub {
      name = "limit-speed";
      owner = "yaoweibin";
      repo = "nginx_limit_speed_module";
      rev = "f77ad4a56fbb134878e75827b40cf801990ed936";
      sha256 = "0kkrd08zpcwx938i2is07vq6pgjkvn97xzjab0g4zaz8bivgmjp8";
    };
  };

  live ={
    src = fetchFromGitHub {
      name = "live";
      owner = "arut";
      repo = "nginx-live-module";
      rev = "5e4a1e3a718e65e5206c24eba00d42b0d1c4b7dd";
      sha256 = "1kpnhl4b50zim84z22ahqxyxfq4jv8ab85kzsy2n5ciqbyg491lz";
    };
  };

  lua = {
    src = fetchFromGitHub {
      name = "lua";
      owner = "openresty";
      repo = "lua-nginx-module";
      rev = "v0.10.15";
      sha256 = "1j216isp0546hycklbr5wi8mlga5hq170hk7f2sm16sfavlkh5gz";
    };
    inputs = [ pkgs.luajit ];
    preConfigure = ''
      export LUAJIT_LIB="${pkgs.luajit}/lib"
      export LUAJIT_INC="${pkgs.luajit}/include/luajit-2.0"
    '';
    allowMemoryWriteExecute = true;
  };

  lua-upstream = {
    src = fetchFromGitHub {
      name = "lua-upstream";
      owner = "openresty";
      repo = "lua-upstream-nginx-module";
      rev = "v0.07";
      sha256 = "1gqccg8airli3i9103zv1zfwbjm27h235qjabfbfqk503rjamkpk";
    };
    inputs = [ pkgs.luajit ];
    allowMemoryWriteExecute = true;
  };

  modsecurity = {
    src = "${pkgs.modsecurity_standalone.nginx}/nginx/modsecurity";
    inputs = [ pkgs.curl pkgs.apr pkgs.aprutil pkgs.apacheHttpd pkgs.yajl ];
    preConfigure = ''
      export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${pkgs.aprutil.dev}/include/apr-1 -I${pkgs.apacheHttpd.dev}/include -I${pkgs.apr.dev}/include/apr-1 -I${pkgs.yajl}/include"
    '';
  };

  modsecurity-nginx = {
    src = fetchFromGitHub {
      name = "modsecurity-nginx";
      owner = "SpiderLabs";
      repo = "ModSecurity-nginx";
      rev = "v1.0.1";
      sha256 = "0cbb3g3g4v6q5zc6an212ia5kjjad62bidnkm8b70i4qv1615pzf";
    };
    inputs = [ pkgs.curl pkgs.geoip pkgs.libmodsecurity pkgs.libxml2 pkgs.lmdb pkgs.yajl ];
  };

  moreheaders = {
    src = fetchFromGitHub {
      name = "moreheaders";
      owner = "openresty";
      repo = "headers-more-nginx-module";
      rev = "v0.33";
      sha256 = "1cgdjylrdd69vlkwwmn018hrglzjwd83nqva1hrapgcfw12f7j53";
    };
  };

  mpeg-ts ={
    src = fetchFromGitHub {
      name = "mpeg-ts";
      owner = "arut";
      repo = "nginx-ts-module";
      rev = "v0.1.1";
      sha256 = "12dxcyy6wna1fccl3a9lnsbymd6p4apnwz6c24w74v97qvpfdxqd";
    };
  };

  naxsi ={
    src = fetchFromGitHub {
      name = "naxsi";
      owner = "nbs-system";
      repo = "naxsi";
      rev = "07a056ccd36bc3c5c40dc17991db226cb8cf6241";
      sha256 = "1kdqy7by6ha2pl9lkkjxh4qrwcsrj2alm8fl129831h5y5xy8qx2";
    } + "/naxsi_src";
  };

  opentracing = {
    src =
      let src' = fetchFromGitHub {
        name = "opentracing";
        owner = "opentracing-contrib";
        repo = "nginx-opentracing";
        rev = "v0.9.0";
        sha256 = "02rf1909grbhvs9mjxrv7pwgbf7b8rpjw7j8rpwxag2rgvlsic3g";
      };
      in "${src'}/opentracing";
    inputs = [ pkgs.opentracing-cpp ];
  };

  pagespeed =
    let
      version = pkgs.psol.version;

      moduleSrc = fetchFromGitHub {
        name   = "pagespeed";
        owner  = "pagespeed";
        repo   = "ngx_pagespeed";
        rev    = "v${version}-stable";
        sha256 = "0ry7vmkb2bx0sspl1kgjlrzzz6lbz07313ks2lr80rrdm2zb16wp";
      };

      ngx_pagespeed = pkgs.runCommand
        "ngx_pagespeed"
        {
          meta = {
            description = "PageSpeed module for Nginx";
            homepage    = "https://developers.google.com/speed/pagespeed/module/";
            license     = pkgs.stdenv.lib.licenses.asl20;
          };
        }
        ''
          cp -r "${moduleSrc}" "$out"
          chmod -R +w "$out"
          ln -s "${pkgs.psol}" "$out/psol"
        '';
    in {
      src = ngx_pagespeed;
      inputs = [ pkgs.zlib pkgs.libuuid ]; # psol deps
      allowMemoryWriteExecute = true;
    };

  pam = {
    src = fetchFromGitHub {
      name = "pam";
      owner = "stogh";
      repo = "ngx_http_auth_pam_module";
      rev = "v1.5.2";
      sha256 = "06nydxk82rc9yrw4408nakb197flxh4z1yv935crg65fn9706rl7";
    };
    inputs = [ pkgs.pam ];
  };

  pinba = {
    src = fetchFromGitHub {
      name = "pinba";
      owner = "tony2001";
      repo = "ngx_http_pinba_module";
      rev = "28131255d4797a7e2f82a6a35cf9fc03c4678fe6";
      sha256 = "00fii8bjvyipq6q47xhjhm3ylj4rhzmlk3qwxmfpdn37j7bc8p8c";
    };
  };

  push-stream ={
    src = fetchFromGitHub {
      name = "push-stream";
      owner = "wandenberg";
      repo = "nginx-push-stream-module";
      rev = "1cdc01521ed44dc614ebb5c0d19141cf047e1f90";
      sha256 = "0ijka32b37dl07k2jl48db5a32ix43jaczrpjih84cvq8yph0jjr";
    };
  };

  rtmp ={
    src = fetchFromGitHub {
      name = "rtmp";
      owner = "arut";
      repo = "nginx-rtmp-module";
      rev = "v1.2.1";
      sha256 = "0na1aam176irz6w148hnvamqy1ilbn4abhdzkva0yrm35a3ksbzn";
    };
  };

  set-misc = {
    src = fetchFromGitHub {
      name = "set-misc";
      owner = "openresty";
      repo = "set-misc-nginx-module";
      rev = "v0.32";
      sha256 = "048a6jwinbjgxiprjj9ml3fdp0mhkx89g6ggams57fsx9m5vaxax";
    };
  };

  shibboleth = {
    src = fetchFromGitHub {
      name = "shibboleth";
      owner = "nginx-shib";
      repo = "nginx-http-shibboleth";
      rev = "5eadab80b2f5940d8873398bca000d93d3f0cf27";
      sha256 = "1l0h3ic9mfsci89d0k5q3igkfpzq052ia25xj5hc8fq388yrhpap";
    };
  };

  sla = {
    src = fetchFromGitHub {
      name = "sla";
      owner = "goldenclone";
      repo = "nginx-sla";
      rev = "7778f0125974befbc83751d0e1cadb2dcea57601";
      sha256 = "1x5hm6r0dkm02ffny8kjd7mmq8przyd9amg2qvy5700x6lb63pbs";
    };
  };

  slowfs-cache = {
    src = fetchFromGitHub {
      name = "slowfs-cache";
      owner  = "FRiCKLE";
      repo   = "ngx_slowfs_cache";
      rev    = "1.10";
      sha256 = "1gyza02pcws3zqm1phv3ag50db5gnapxyjwy8skjmvawz7p5bmxr";
    };
  };

  sorted-querystring = {
    src = fetchFromGitHub {
      name = "sorted-querystring";
      owner = "wandenberg";
      repo = "nginx-sorted-querystring-module";
      rev = "0.3";
      sha256 = "0p6b0hcws39n27fx4xp9k4hb3pcv7b6kah4qqaj0pzjy3nbp4gj7";
    };
  };

  statsd = {
    src = fetchFromGitHub {
      name = "statsd";
      owner = "harvesthq";
      repo = "nginx-statsd";
      rev = "b970e40467a624ba710c9a5106879a0554413d15";
      sha256 = "1x8j4i1i2ahrr7qvz03vkldgdjdxi6mx75mzkfizfcc8smr4salr";
    };
  };

  stream-sts = {
    src = fetchFromGitHub {
      name = "stream-sts";
      owner = "vozlt";
      repo = "nginx-module-stream-sts";
      rev = "v0.1.1";
      sha256 = "1jdj1kik6l3rl9nyx61xkqk7hmqbncy0rrqjz3dmjqsz92y8zaya";
    };
  };

  sts = {
    src = fetchFromGitHub {
      name = "sts";
      owner = "vozlt";
      repo = "nginx-module-sts";
      rev = "v0.1.1";
      sha256 = "0nvb29641x1i7mdbydcny4qwlvdpws38xscxirajd2x7nnfdflrk";
    };
  };

  subsFilter = {
    src = fetchFromGitHub {
      name = "subsFilter";
      owner = "yaoweibin";
      repo = "ngx_http_substitutions_filter_module";
      rev = "b8a71eacc7f986ba091282ab8b1bbbc6ae1807e0";
      sha256 = "027jxzx66q9a6ycn47imjh40xmnqr0z423lz0ds3w4rf1c2x130f";
    };
  };

  sysguard = {
    src = fetchFromGitHub {
      name = "sysguard";
      owner = "vozlt";
      repo = "nginx-module-sysguard";
      rev = "e512897f5aba4f79ccaeeebb51138f1704a58608";
      sha256 = "19c6w6wscbq9phnx7vzbdf4ay6p2ys0g7kp2rmc9d4fb53phrhfx";
    };
  };

  upstream-check = {
    src = fetchFromGitHub {
      name = "upstream-check";
      owner = "yaoweibin";
      repo = "nginx_upstream_check_module";
      rev = "e538034b6ad7992080d2403d6d3da56e4f7ac01e";
      sha256 = "06y7k04072xzqyqyb08m0vaaizkp4rfwm0q7i735imbzw2rxb74l";
    };
  };

  upstream-tarantool = {
    src = fetchFromGitHub {
      name = "upstream-tarantool";
      owner = "tarantool";
      repo = "nginx_upstream_module";
      rev = "v2.7.1";
      sha256 = "0ya4330in7zjzqw57djv4icpk0n1j98nvf0f8v296yi9rjy054br";
    };
    inputs = [ pkgs.msgpuck.dev pkgs.yajl ];
  };

  url = {
    src = fetchFromGitHub {
      name = "url";
      owner = "vozlt";
      repo = "nginx-module-url";
      rev = "9299816ca6bc395625c3683fbd2aa7b916bfe91e";
      sha256 = "0mk1gjmfnry6hgdsnlavww9bn7223idw50jlkhh5k00q5509w4ip";
    };
  };

  video-thumbextractor = {
    src = fetchFromGitHub {
      name = "video-thumbextractor";
      owner = "wandenberg";
      repo = "nginx-video-thumbextractor-module";
      rev = "0.9.0";
      sha256 = "1b0v471mzbcys73pzr7gpvzzhff0cva0l5ff32cv7z1v9c0ypji7";
    };
    inputs = [ pkgs.ffmpeg_3 ];
  };

  vts = {
    src = fetchFromGitHub {
      name = "vts";
      owner = "vozlt";
      repo = "nginx-module-vts";
      rev = "v0.1.18";
      sha256 = "1jq2s9k7hah3b317hfn9y3g1q4g4x58k209psrfsqs718a9sw8c7";
    };
  };
}
