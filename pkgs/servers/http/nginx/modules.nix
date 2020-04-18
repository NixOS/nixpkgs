{ fetchFromGitHub, lib, pkgs }:

let

  http_proxy_connect_module_generic = patchName: rec {
    src = fetchFromGitHub {
      owner = "chobits";
      repo = "ngx_http_proxy_connect_module";
      rev = "002f8f9ef15562dc3691b977134518ad216d7a90";
      sha256 = "163wg0xb7w5mwh6wrfarzcgaf6c7gb5qydgpi2wk35k551f7286s";
    };

    patches = [
      "${src}/patch/${patchName}.patch"
    ];
  };

in

{
  brotli = {
    src = let gitsrc = pkgs.fetchFromGitHub {
      owner = "google";
      repo = "ngx_brotli";
      rev = "e505dce68acc190cc5a1e780a3b0275e39f160ca";
      sha256 = "00j48lffki62y1nmjyy81iklw5nlyzvrjy3z04qch4fp3p57hwla";
    }; in pkgs.runCommandNoCC "ngx_brotli-src" {} ''
      cp -a ${gitsrc} $out
      substituteInPlace $out/filter/config \
        --replace '$ngx_addon_dir/deps/brotli/c' ${lib.getDev pkgs.brotli}
    '';
    inputs = [ pkgs.brotli ];
  };

  coolkit = {
    src = fetchFromGitHub {
      owner  = "FRiCKLE";
      repo   = "ngx_coolkit";
      rev    = "0.2";
      sha256 = "1idj0cqmfsdqawjcqpr1fsq670fdki51ksqk2lslfpcs3yrfjpqh";
    };
  };

  dav = {
    src = fetchFromGitHub {
      owner = "arut";
      repo = "nginx-dav-ext-module";
      rev = "v3.0.0";
      sha256 = "000dm5zk0m1hm1iq60aff5r6y8xmqd7djrwhgnz9ig01xyhnjv9w";
    };
    inputs = [ pkgs.expat ];
  };

  develkit = {
    src = fetchFromGitHub {
      owner = "simpl";
      repo = "ngx_devel_kit";
      rev = "v0.3.1rc1";
      sha256 = "00vqvpx67qra2hr85hkvj1dha4h7x7v9sblw7w1df11nq1gzsdbb";
    };
  };

  echo = {
    src = fetchFromGitHub {
      owner = "openresty";
      repo = "echo-nginx-module";
      rev = "v0.61";
      sha256 = "0brjhhphi94ms4gia7za0mfx0png4jbhvq6j0nzjwp537iyiy23k";
    };
  };

  fancyindex = {
    src = fetchFromGitHub {
      owner = "aperezdc";
      repo = "ngx-fancyindex";
      rev = "v0.4.3";
      sha256 = "12xdx6a76sfrq0yciylvyjlnvyczszpadn31jqya8c2dzdkyyx7f";
    };
  };

  fastcgi-cache-purge = {
    src = fetchFromGitHub {
      owner  = "nginx-modules";
      repo   = "ngx_cache_purge";
      rev    = "2.5";
      sha256 = "1f4kxagzvz10vqbcjwi57wink6xw3s1h7wlrrlrlpkmhfbf9704y";
    };
  };

  fluentd = {
    src = fetchFromGitHub {
      owner = "fluent";
      repo = "nginx-fluentd-module";
      rev = "8af234043059c857be27879bc547c141eafd5c13";
      sha256 = "1ycb5zd9sw60ra53jpak1m73zwrjikwhrrh9q6266h1mlyns7zxm";
    };
  };

  http_proxy_connect_module_v16 = http_proxy_connect_module_generic "proxy_connect_rewrite_101504" // {
    supports = with lib.versions; version: major version == "1" && minor version == "16";
  };

  ipscrub = {
    src = fetchFromGitHub {
      owner = "masonicboom";
      repo = "ipscrub";
      rev = "v1.0.1";
      sha256 = "0qcx15c8wbsmyz2hkmyy5yd7qn1n84kx9amaxnfxkpqi05vzm1zz";
    } + "/ipscrub";
    inputs = [ pkgs.libbsd ];
  };

  limit-speed = {
    src = fetchFromGitHub {
      owner = "yaoweibin";
      repo = "nginx_limit_speed_module";
      rev = "f77ad4a56fbb134878e75827b40cf801990ed936";
      sha256 = "0kkrd08zpcwx938i2is07vq6pgjkvn97xzjab0g4zaz8bivgmjp8";
    };
  };

  live ={
    src = fetchFromGitHub {
      owner = "arut";
      repo = "nginx-live-module";
      rev = "5e4a1e3a718e65e5206c24eba00d42b0d1c4b7dd";
      sha256 = "1kpnhl4b50zim84z22ahqxyxfq4jv8ab85kzsy2n5ciqbyg491lz";
    };
  };

  lua = {
    src = fetchFromGitHub {
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
  };

  lua-upstream = {
    src = fetchFromGitHub {
      owner = "openresty";
      repo = "lua-upstream-nginx-module";
      rev = "v0.07";
      sha256 = "1gqccg8airli3i9103zv1zfwbjm27h235qjabfbfqk503rjamkpk";
    };
    inputs = [ pkgs.luajit ];
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
      owner = "SpiderLabs";
      repo = "ModSecurity-nginx";
      rev = "v1.0.0";
      sha256 = "0zzpdqhbdqqy8kjkszv0mrq6136ah9v3zwr1jbh312j8izmzdyi7";
    };
    inputs = [ pkgs.curl pkgs.geoip pkgs.libmodsecurity pkgs.libxml2 pkgs.lmdb pkgs.yajl ];
  };

  moreheaders = {
    src = fetchFromGitHub {
      owner = "openresty";
      repo = "headers-more-nginx-module";
      rev = "v0.33";
      sha256 = "1cgdjylrdd69vlkwwmn018hrglzjwd83nqva1hrapgcfw12f7j53";
    };
  };

  mpeg-ts ={
    src = fetchFromGitHub {
      owner = "arut";
      repo = "nginx-ts-module";
      rev = "v0.1.1";
      sha256 = "12dxcyy6wna1fccl3a9lnsbymd6p4apnwz6c24w74v97qvpfdxqd";
    };
  };

  naxsi ={
    src = fetchFromGitHub {
      owner = "nbs-system";
      repo = "naxsi";
      rev = "0.56";
      sha256 = "12kn6wbl8xqc19fi05ffprqps4pplg4a6i1cf01xc0d6brx1fg8v";
    } + "/naxsi_src";
  };

  ngx_aws_auth = {
    src = fetchFromGitHub {
      owner = "anomalizer";
      repo = "ngx_aws_auth";
      rev = "2.1.1";
      sha256 = "10z67g40w7wpd13fwxyknkbg3p6hn61i4v8xw6lh27br29v1y6h9";
    };
  };

  opentracing = {
    src =
      let src' = fetchFromGitHub {
        owner = "opentracing-contrib";
        repo = "nginx-opentracing";
        rev = "v0.7.0";
        sha256 = "16jzxhhsyfjaxb50jy5py9ppscidfx1shvc29ihldp0zs6d8khma";
      };
      in "${src'}/opentracing";
    inputs = [ pkgs.opentracing-cpp ];
  };

  pagespeed =
    let
      version = pkgs.psol.version;

      moduleSrc = fetchFromGitHub {
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
    };

  pam = {
    src = fetchFromGitHub {
      owner = "stogh";
      repo = "ngx_http_auth_pam_module";
      rev = "v1.5.1";
      sha256 = "031q006bcv10dzxi3mzamqiyg14p48v0bzd5mrwz073pbf0ba2fl";
    };
    inputs = [ pkgs.pam ];
  };

  pinba = {
    src = fetchFromGitHub {
      owner = "tony2001";
      repo = "ngx_http_pinba_module";
      rev = "28131255d4797a7e2f82a6a35cf9fc03c4678fe6";
      sha256 = "00fii8bjvyipq6q47xhjhm3ylj4rhzmlk3qwxmfpdn37j7bc8p8c";
    };
  };

  push-stream ={
    src = fetchFromGitHub {
      owner = "wandenberg";
      repo = "nginx-push-stream-module";
      rev = "0.5.4";
      sha256 = "0izn7lqrp2zfl738aqa9i8c5lba97wkhcnqg8qbw3ipp5cysb2hr";
    };
  };

  rtmp ={
    src = fetchFromGitHub {
      owner = "arut";
      repo = "nginx-rtmp-module";
      rev = "v1.2.1";
      sha256 = "0na1aam176irz6w148hnvamqy1ilbn4abhdzkva0yrm35a3ksbzn";
    };
  };

  set-misc = {
    src = fetchFromGitHub {
      owner = "openresty";
      repo = "set-misc-nginx-module";
      rev = "v0.32";
      sha256 = "048a6jwinbjgxiprjj9ml3fdp0mhkx89g6ggams57fsx9m5vaxax";
    };
  };

  shibboleth = {
    src = fetchFromGitHub {
      owner = "nginx-shib";
      repo = "nginx-http-shibboleth";
      rev = "48b70d87bf7796d7813813a837e52b3a86e6f6f4";
      sha256 = "0k8xcln5sf0m4r0m550dkhl07zhncp285dpysk6r4v6vqzqmhzdc";
    };
  };

  sla = {
    src = fetchFromGitHub {
      owner = "goldenclone";
      repo = "nginx-sla";
      rev = "7778f0125974befbc83751d0e1cadb2dcea57601";
      sha256 = "1x5hm6r0dkm02ffny8kjd7mmq8przyd9amg2qvy5700x6lb63pbs";
    };
  };

  slowfs-cache = {
    src = fetchFromGitHub {
      owner  = "FRiCKLE";
      repo   = "ngx_slowfs_cache";
      rev    = "1.10";
      sha256 = "1gyza02pcws3zqm1phv3ag50db5gnapxyjwy8skjmvawz7p5bmxr";
    };
  };

  sorted-querystring = {
    src = fetchFromGitHub {
      owner = "wandenberg";
      repo = "nginx-sorted-querystring-module";
      rev = "0.3";
      sha256 = "0p6b0hcws39n27fx4xp9k4hb3pcv7b6kah4qqaj0pzjy3nbp4gj7";
    };
  };

  statsd = {
    src = fetchFromGitHub {
      owner = "apcera";
      repo = "nginx-statsd";
      rev = "b970e40467a624ba710c9a5106879a0554413d15";
      sha256 = "1x8j4i1i2ahrr7qvz03vkldgdjdxi6mx75mzkfizfcc8smr4salr";
    };
  };

  stream-sts = {
    src = fetchFromGitHub {
      owner = "vozlt";
      repo = "nginx-module-stream-sts";
      rev = "v0.1.1";
      sha256 = "1jdj1kik6l3rl9nyx61xkqk7hmqbncy0rrqjz3dmjqsz92y8zaya";
    };
  };

  sts = {
    src = fetchFromGitHub {
      owner = "vozlt";
      repo = "nginx-module-sts";
      rev = "v0.1.1";
      sha256 = "0nvb29641x1i7mdbydcny4qwlvdpws38xscxirajd2x7nnfdflrk";
    };
  };

  subsFilter = {
    src = fetchFromGitHub {
      owner = "yaoweibin";
      repo = "ngx_http_substitutions_filter_module";
      rev = "bc58cb11844bc42735bbaef7085ea86ace46d05b";
      sha256 = "1q5hr3sqys4f365gzjci549rn9ylhgj4xb29ril04zr5vkhzlnar";
    };
  };

  sysguard = {
    src = fetchFromGitHub {
      owner = "vozlt";
      repo = "nginx-module-sysguard";
      rev = "e512897f5aba4f79ccaeeebb51138f1704a58608";
      sha256 = "19c6w6wscbq9phnx7vzbdf4ay6p2ys0g7kp2rmc9d4fb53phrhfx";
    };
  };

  upstream-check = {
    src = fetchFromGitHub {
      owner = "yaoweibin";
      repo = "nginx_upstream_check_module";
      rev = "007f76f7adbcbd6abd9352502af1a4ae463def85";
      sha256 = "1qcg7c9rcl70wr1qf188shnn9s2f7cxnlw05s6scbvlgnf6ik6in";
    };
  };

  upstream-tarantool = {
    src = fetchFromGitHub {
      owner = "tarantool";
      repo = "nginx_upstream_module";
      rev = "v2.7.1";
      sha256 = "0ya4330in7zjzqw57djv4icpk0n1j98nvf0f8v296yi9rjy054br";
    };
    inputs = [ pkgs.msgpuck.dev pkgs.yajl ];
  };

  url = {
    src = fetchFromGitHub {
      owner = "vozlt";
      repo = "nginx-module-url";
      rev = "9299816ca6bc395625c3683fbd2aa7b916bfe91e";
      sha256 = "0mk1gjmfnry6hgdsnlavww9bn7223idw50jlkhh5k00q5509w4ip";
    };
  };

  video-thumbextractor = {
    src = fetchFromGitHub {
      owner = "wandenberg";
      repo = "nginx-video-thumbextractor-module";
      rev = "0.9.0";
      sha256 = "1b0v471mzbcys73pzr7gpvzzhff0cva0l5ff32cv7z1v9c0ypji7";
    };
    inputs = [ pkgs.ffmpeg ];
  };

  vts = {
    src = fetchFromGitHub {
      owner = "vozlt";
      repo = "nginx-module-vts";
      rev = "v0.1.18";
      sha256 = "1jq2s9k7hah3b317hfn9y3g1q4g4x58k209psrfsqs718a9sw8c7";
    };
  };
}
