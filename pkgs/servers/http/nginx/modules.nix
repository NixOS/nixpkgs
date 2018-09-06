{ fetchFromGitHub, lib, pkgs }:

{
  brotli = {
    src = let gitsrc = pkgs.fetchFromGitHub {
      owner = "eustas";
      repo = "ngx_brotli";
      rev = "v0.1.2";
      sha256 = "19r9igxm4hrzrhxajlxw2ccq0057h8ipkfiif725x0xqbxjskl6c";
    }; in pkgs.runCommandNoCC "ngx_brotli-src" {} ''
      cp -a ${gitsrc} $out
      substituteInPlace $out/config \
        --replace /usr/local ${lib.getDev pkgs.brotli}
    '';
    inputs = [ pkgs.brotli ];
  };

  dav = {
    src = fetchFromGitHub {
      owner = "arut";
      repo = "nginx-dav-ext-module";
      rev = "v0.1.0";
      sha256 = "1ifahd69vz715g3zim618jbmxb7kcmzykc696grskxm0svpy294k";
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
      owner  = "FRiCKLE";
      repo   = "ngx_cache_purge";
      rev    = "2.3";
      sha256 = "0ib2jrbjwrhvmihhnzkp4w87fxssbbmmmj6lfdwpm6ni8p9g60dw";
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

  ipscrub = {
    src = fetchFromGitHub {
      owner = "masonicboom";
      repo = "ipscrub";
      rev = "v1.0.1";
      sha256 = "0qcx15c8wbsmyz2hkmyy5yd7qn1n84kx9amaxnfxkpqi05vzm1zz";
    } + "/ipscrub";
    inputs = [ pkgs.libbsd ];
  };

  lua = {
    src = fetchFromGitHub {
      owner = "openresty";
      repo = "lua-nginx-module";
      rev = "v0.10.13";
      sha256 = "19mpc76lfhyyvkfs2n08b4rc9cf2v7rm8fskkf60hsdcf6qna822";
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
      rev = "9aecf15ec379fe98f62355c57b60c0bc83296f04";
      sha256 = "1cjisxw1wykll683nw09k0i1nvzslp4dr59x58cvarpk43paim2y";
    };
  };

  upstream-tarantool = {
    src = fetchFromGitHub {
      owner = "tarantool";
      repo = "nginx_upstream_module";
      rev = "v2.7";
      sha256 = "05dwj0caj910p7kan2qjvm6x2x601igryhny2xzr47hhsk5q1cnx";
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

  vts = {
    src = fetchFromGitHub {
      owner = "vozlt";
      repo = "nginx-module-vts";
      rev = "v0.1.18";
      sha256 = "1jq2s9k7hah3b317hfn9y3g1q4g4x58k209psrfsqs718a9sw8c7";
    };
  };
}
