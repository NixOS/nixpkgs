{ fetchFromGitHub, pkgs }:

{
  brotli = {
    src = fetchFromGitHub {
      owner = "google";
      repo = "ngx_brotli";
      rev = "788615eab7c5e0a984278113c55248305620df14";
      sha256 = "02514bbjdhm9m38vljdh626d3c1783jxsxawv5c6bzblwmb8xgvf";
    };
    inputs = [ pkgs.libbrotli ];
  };

  rtmp = {
    src = fetchFromGitHub {
      owner = "arut";
      repo = "nginx-rtmp-module";
      rev = "v1.1.11";
      sha256 = "09zrnf8lk179mpqnx92zm24xl7m3bq4ca84wc2zwi5hc8kxjbwxc";
    };
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

  moreheaders = {
    src = fetchFromGitHub {
      owner = "openresty";
      repo = "headers-more-nginx-module";
      rev = "v0.26";
      sha256 = "0zhr3ai4xf5yghxvlbrwv8n06fgx33f1n1d4a6gmsczdfjzf8g6g";
    };
  };

  modsecurity = {
    src = "${pkgs.modsecurity_standalone.nginx}/nginx/modsecurity";
    inputs = [ pkgs.curl pkgs.apr pkgs.aprutil pkgs.apacheHttpd pkgs.yajl ];
    preConfigure = ''
      export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${pkgs.aprutil.dev}/include/apr-1 -I${pkgs.apacheHttpd.dev}/include -I${pkgs.apr.dev}/include/apr-1 -I${pkgs.yajl}/include"
    '';
  };

  echo = {
    src = fetchFromGitHub {
      owner = "openresty";
      repo = "echo-nginx-module";
      rev = "v0.61";
      sha256 = "0brjhhphi94ms4gia7za0mfx0png4jbhvq6j0nzjwp537iyiy23k";
    };
  };

  develkit = {
    src = fetchFromGitHub {
      owner = "simpl";
      repo = "ngx_devel_kit";
      rev = "v0.3.0";
      sha256 = "1br1997zqsjcb1aqm6h6xmi5yx7akxk0qvk8wxc0fnvmyhgzxgx0";
    };
  };

  lua = {
    src = fetchFromGitHub {
      owner = "openresty";
      repo = "lua-nginx-module";
      rev = "v0.10.10";
      sha256 = "1dlqnlkpn3pnhk2m09jdx3iw3m6xk31pw2m5xrpcmqk3bll68mw6";
    };
    inputs = [ pkgs.luajit ];
    preConfigure = ''
      export LUAJIT_LIB="${pkgs.luajit}/lib"
      export LUAJIT_INC="${pkgs.luajit}/include/luajit-2.0"
    '';
  };

  set-misc = {
    src = fetchFromGitHub {
      owner = "openresty";
      repo = "set-misc-nginx-module";
      rev = "v0.28";
      sha256 = "1vixj60q0liri7k5ax85grj7q9vvgybkx421bwphbhai5xrjip96";
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

  pam = {
    src = fetchFromGitHub {
      owner = "stogh";
      repo = "ngx_http_auth_pam_module";
      rev = "v1.4";
      sha256 = "068zwyrc1dji55rlaj2kx6n0v2n5rpj7nz26ipvz26ida712md35";
    };
    inputs = [ pkgs.pam ];
  };

  statsd = {
    src = fetchFromGitHub {
      owner = "apcera";
      repo = "nginx-statsd";
      rev = "2147d61dc31dd4865604be92349e6192a905d21a";
      sha256 = "19s3kwjgf51jkwknh7cfi82p6kifl8rl146wxc3ijds12776ilsv";
    };
  };

  upstream-check = {
    src = fetchFromGitHub {
      owner = "yaoweibin";
      repo = "nginx_upstream_check_module";
      rev = "10782eaff51872a8f44e65eed89bbe286004bcb1";
      sha256 = "0h98a8kiw2qkqfavysm1v16kf4cs4h39j583wapif4p0qx3bbm89";
    };
  };

  # For an example usage, see https://easyengine.io/wordpress-nginx/tutorials/single-site/fastcgi-cache-with-purging/
  fastcgi-cache-purge = {
    src = fetchFromGitHub {
      owner  = "FRiCKLE";
      repo   = "ngx_cache_purge";
      rev    = "2.3";
      sha256 = "0ib2jrbjwrhvmihhnzkp4w87fxssbbmmmj6lfdwpm6ni8p9g60dw";
    };
  };

  pagespeed =
    let
      version = pkgs.psol.version;

      moduleSrc = fetchFromGitHub {
        owner  = "pagespeed";
        repo   = "ngx_pagespeed";
        rev    = "v${version}-beta";
        sha256 = "03dvzf1lgsjxcs1jjxq95n2rhgq0wy0f9ahvgascy0fak7qx4xj9";
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
    };

    shibboleth = {
      src = fetchFromGitHub {
        owner = "nginx-shib";
        repo = "nginx-http-shibboleth";
        rev = "48b70d87bf7796d7813813a837e52b3a86e6f6f4";
        sha256 = "0k8xcln5sf0m4r0m550dkhl07zhncp285dpysk6r4v6vqzqmhzdc";
      };
    };
}
