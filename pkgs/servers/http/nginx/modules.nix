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
      rev = "v1.1.9";
      sha256 = "19vqw1ba01m2wlncpycw9vj5n8741pv36hd3dy9jjdxwlzdjzyi5";
    };
  };

  dav = {
    src = fetchFromGitHub {
      owner = "arut";
      repo = "nginx-dav-ext-module";
      rev = "v0.0.3";
      sha256 = "1qck8jclxddncjad8yv911s9z7lrd58bp96jf13m0iqk54xghx91";
    };
    inputs = [ pkgs.expat ];
  };

  syslog = rec {
    src = fetchFromGitHub {
      owner = "yaoweibin";
      repo = "nginx_syslog_patch";
      rev = "3ca5ba65541637f74467038aa032e2586321d0cb";
      sha256 = "0y8dxkx8m1jw4v5zsvw1gfah9vh3ryq0hfmrcbjzcmwp5b5lb1i8";
    };
    preConfigure = ''
      patch -p1 < "${src}/syslog-1.7.0.patch"
    '';
  };

  moreheaders = {
    src = fetchFromGitHub {
      owner = "openresty";
      repo = "headers-more-nginx-module";
      rev = "v0.26";
      sha256 = "01wkqhk8mk8jgmzi7jbzmg5kamffx3lmhj5yfwryvnvs6xqs74wn";
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
      rev = "v0.57";
      sha256 = "1q0f0zprcn0ypl2qh964cq186l3f40p0z7n7x22m8cxj367vf000";
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
      rev = "v0.10.5";
      sha256 = "0wz5j4kqa6hk7ar42bkxp0hd74psjy6sfsldh1a6p93z349iz4v5";
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
}
