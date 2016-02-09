{ stdenv, writeScriptBin, lib, fetchurl, fetchFromGitHub
, erlang, openssl, expat, libyaml, bash, gnused, gnugrep, coreutils, utillinux, procps
, withMysql ? false
, withPgsql ? false
, withSqlite ? false, sqlite
, withPam ? false, pam
, withZlib ? true, zlib
, withRiak ? false
, withElixir ? false, elixir
, withIconv ? true
, withLager ? true
, withTools ? false
, withRedis ? false
}:

let
  ctlpath = lib.makeSearchPath "bin" [ bash gnused gnugrep coreutils utillinux procps ];

  fakegit = writeScriptBin "git" ''
    #! ${stdenv.shell}
    exit 0
  '';

  # These can be extracted from `rebar.config.script`
  # Some dependencies are from another packages. Try commenting them out; then during build
  # you'll get necessary revision information.
  ejdeps = {
    p1_cache_tab = fetchFromGitHub {
      owner = "processone";
      repo = "cache_tab";
      rev = "f7ea12b0ba962a3d2f9a406d2954cf7de4e27230";
      sha256 = "043rz66s6vhcbk02qjhn1r8jv8yyy4gk0gsknmk7ya6wq2v1farw";
    };
    p1_tls = fetchFromGitHub {
      owner = "processone";
      repo = "tls";
      rev = "e56321afd974e9da33da913cd31beebc8e73e75f";
      sha256 = "0k8dx8mww2ilr4y5m2llhqh673l0z7r73f0lh7klyf57wfqy7hzk";
    };
    p1_stringprep = fetchFromGitHub {
      owner = "processone";
      repo = "stringprep";
      rev = "3c640237a3a7831dc39de6a6d329d3a9af25c579";
      sha256 = "0mwlkivkfj16bdv80jr8kqa0vcqglxkq90m9qn0m6zp4bjc3jm3n";
    };
    p1_xml = fetchFromGitHub {
      owner = "processone";
      repo = "xml";
      rev = "1c8b016b0ac7986efb823baf1682a43565449e65";
      sha256 = "192jhj0cwwypbiass3rm2449410pqyk3mgrdg7yyvqwmjzzkmh87";
    };
    esip = fetchFromGitHub {
      owner = "processone";
      repo = "p1_sip";
      rev = "d662d3fe7f6288b444ea321d854de0bd6d40e022";
      sha256 = "1mwzkkv01vr9n13h6h3100jrrlgb683ncq9jymnbxqxk6rn7xjd1";
    };
    p1_stun = fetchFromGitHub {
      owner = "processone";
      repo = "stun";
      rev = "061bdae484268cbf0457ad4797e74b8516df3ad1";
      sha256 = "0zaw8yq4sk7x4ybibcq93k9b6rb7fn03i0k8gb2dnlipmbcdd8cf";
    };
    p1_yaml = fetchFromGitHub {
      owner = "processone";
      repo = "p1_yaml";
      rev = "79f756ba73a235c4d3836ec07b5f7f2b55f49638";
      sha256 = "05jjw02ay8v34izwgi5zizqp1mj68ypjilxn59c262xj7c169pzh";
    };
    p1_utils = fetchFromGitHub {
      owner = "processone";
      repo = "p1_utils";
      rev = "d7800881e6702723ce58b7646b60c9e4cd25d563";
      sha256 = "07p47ccrdjymjmn6rn9jlcyg515bs9l0iwfbc75qsk10ddnmbvdi";
    };
    jiffy = fetchFromGitHub {
      owner = "davisp";
      repo = "jiffy";
      rev = "cfc61a2e952dc3182e0f9b1473467563699992e2";
      sha256 = "1c2x71x90jlx4585znxz8fg46q3jxm80nk7v184lf4pqa1snk8kk";
    };
    oauth2 = fetchFromGitHub {
      owner = "prefiks";
      repo = "oauth2";
      rev = "e6da9912e5d8f658e7e868f41a102d085bdbef59";
      sha256 = "0di33bkj8xc7h17z1fs4birp8a88c1ds72jc4xz2qmz8kh7q9m3k";
    };
    xmlrpc = fetchFromGitHub {
      owner = "rds13";
      repo = "xmlrpc";
      rev = "42e6e96a0fe7106830274feed915125feb1056f3";
      sha256 = "10dk480s6z653lr5sap4rcx3zsfmg68hgapvc4jvcyf7vgg12d3s";
    };

    p1_mysql = fetchFromGitHub {
      owner = "processone";
      repo = "mysql";
      rev = "dfa87da95f8fdb92e270741c2a53f796b682f918";
      sha256 = "1nw7n1xvid4yqp57s94drdjf6ffap8zpy8hkrz9yffzkhk9biz5y";
    };
    p1_pgsql = fetchFromGitHub {
      owner = "processone";
      repo = "pgsql";
      rev = "e72c03c60bfcb56bbb5d259342021d9cb3581dac";
      sha256 = "0y89995h7g8bi12qi1m4cdzcswsljbv7y8zb43rjg5ss2bcq7kb6";
    };
    sqlite3 = fetchFromGitHub {
      owner = "alexeyr";
      repo = "erlang-sqlite3";
      rev = "8350dc603804c503f99c92bfd2eab1dd6885758e";
      sha256 = "0d0pbqmi3hsvzjp4vjp7a6bq3pjvkfv0spszh6485x9cmxsbwfpc";
    };
    p1_pam = fetchFromGitHub {
      owner = "processone";
      repo = "epam";
      rev = "d3ce290b7da75d780a03e86e7a8198a80e9826a6";
      sha256 = "0s0czrgjvc1nw7j66x8b9rlajcap0yfnv6zqd4gs76ky6096qpb0";
    };
    p1_zlib = fetchFromGitHub {
      owner = "processone";
      repo = "zlib";
      rev = "e3d4222b7aae616d7ef2e7e2fa0bbf451516c602";
      sha256 = "0z960nwva8x4lw1k91i53kpn2bjbf1v1amslkyp8sx2gc5zf0gbn";
    };
    riakc = fetchFromGitHub {
      owner = "basho";
      repo = "riak-erlang-client";
      rev = "1.4.2";
      sha256 = "128jz83n1990m9c2fzwsif6hyapmq46720nzfyyb4z2j75vn85zz";
    };
    # dependency of riakc
    riak_pb = fetchFromGitHub {
      owner = "basho";
      repo = "riak_pb";
      rev = "1.4.4.0";
      sha256 = "054fg9gaxk4n0id0qs6k8i919qvxsvmh76m6fgfbmixyfxh5jp3w";
    };
    # dependency of riak_pb
    protobuffs = fetchFromGitHub {
      owner = "basho";
      repo = "erlang_protobuffs";
      rev = "0.8.1p1";
      sha256 = "1x75a26y1gx6pzr829i4sx2mxm5w40kb6hfd5y511him56jcczna";
    };
    rebar_elixir_plugin = fetchFromGitHub {
      owner = "yrashk";
      repo = "rebar_elixir_plugin";
      rev = "7058379b7c7e017555647f6b9cecfd87cd50f884";
      sha256 = "1s5bvbrhal866gbp72lgp0jzphs2cmgmafmka0pylwj30im41c71";
    };
    elixir = fetchFromGitHub {
      owner = "elixir-lang";
      repo = "elixir";
      rev = "1d9548fd285d243721b7eba71912bde2ffd1f6c3";
      sha256 = "1lxn9ly73rm797p6slfx7grsq32nn6bz15qhkbra834rj01fqzh8";
    };
    p1_iconv = fetchFromGitHub {
      owner = "processone";
      repo = "eiconv";
      rev = "8b7542b1aaf0a851f335e464956956985af6d9a2";
      sha256 = "1w3k41fpynqylc2vnirz0fymlidpz0nnym0070f1f1s3pd6g5906";
    };
    lager = fetchFromGitHub {
      owner = "basho";
      repo = "lager";
      rev = "4d2ec8c701e1fa2d386f92f2b83b23faf8608ac3";
      sha256 = "03aav3cid0qpl1n8dn83hk0p70rw05nqvhq1abdh219nrlk9gfmx";
    };
    # dependency of lager
    goldrush = fetchFromGitHub {
      owner = "DeadZen";
      repo = "goldrush";
      rev = "0.1.7";
      sha256 = "1104j8v86hdavxf08yjyjkpi5vf95rfvsywdx29c69x3z33i4z3m";
    };
    p1_logger = fetchFromGitHub {
      owner = "processone";
      repo = "p1_logger";
      rev = "3e19507fd5606a73694917158767ecb3f5704e3f";
      sha256 = "0mq86gh8x3bgqcpwdjkdn7m3bj2006gbarnj7cn5dfs21m2h2mdn";
    };
    meck = fetchFromGitHub {
      owner = "eproxus";
      repo = "meck";
      rev = "fc362e037f424250130bca32d6bf701f2f49dc75";
      sha256 = "056yca394f8mbg8vwxxlq47dbjx48ykdrg4lvnbi5gfijl786i3s";
    };
    eredis = fetchFromGitHub {
      owner = "wooga";
      repo = "eredis";
      rev = "770f828918db710d0c0958c6df63e90a4d341ed7";
      sha256 = "0qv8hldn5972328pa1qz2lbblw1p2283js5y98dc8papldkicvmm";
    };

  };

in stdenv.mkDerivation rec {
  version = "15.11";
  name = "ejabberd-${version}";

  src = fetchurl {
    url = "http://www.process-one.net/downloads/ejabberd/${version}/${name}.tgz";
    sha256 = "0sll1si9pd4v7yibzr8hp18hfrbxsa5nj9h7qsldvy7r4md4n101";
  };

  nativeBuildInputs = [ fakegit ];

  buildInputs = [ erlang openssl expat libyaml ]
    ++ lib.optional withSqlite sqlite
    ++ lib.optional withPam pam
    ++ lib.optional withZlib zlib
    ++ lib.optional withElixir elixir
    ;

  # Apparently needed for Elixir
  LANG = "en_US.UTF-8";

  depsNames =
    [ "p1_cache_tab" "p1_tls" "p1_stringprep" "p1_xml" "esip" "p1_stun" "p1_yaml" "p1_utils" "jiffy" "oauth2" "xmlrpc" ]
    ++ lib.optional withMysql "p1_mysql"
    ++ lib.optional withPgsql "p1_pgsql"
    ++ lib.optional withSqlite "sqlite3"
    ++ lib.optional withPam "p1_pam"
    ++ lib.optional withZlib "p1_zlib"
    ++ lib.optionals withRiak [ "riakc" "riak_pb" "protobuffs" ]
    ++ lib.optionals withElixir [ "rebar_elixir_plugin" "elixir" ]
    ++ lib.optional withIconv "p1_iconv"
    ++ lib.optionals withLager [ "lager" "goldrush" ]
    ++ lib.optional (!withLager) "p1_logger"
    ++ lib.optional withTools "meck"
    ++ lib.optional withRedis "eredis"
  ;

  configureFlags =
    [ "--enable-nif"
      (lib.enableFeature withMysql "mysql")
      (lib.enableFeature withPgsql "pgsql")
      (lib.enableFeature withSqlite "sqlite")
      (lib.enableFeature withPam "pam")
      (lib.enableFeature withZlib "zlib")
      (lib.enableFeature withRiak "riak")
      (lib.enableFeature withElixir "elixir")
      (lib.enableFeature withIconv "iconv")
      (lib.enableFeature withLager "lager")
      (lib.enableFeature withTools "tools")
      (lib.enableFeature withRedis "redis")
    ] ++ lib.optional withSqlite "--with-sqlite3=${sqlite}";

  depsPaths = map (x: builtins.getAttr x ejdeps) depsNames;

  enableParallelBuilding = true;

  preBuild = ''
    mkdir deps
    depsPathsA=( $depsPaths )
    depsNamesA=( $depsNames )
    for i in {0..${toString (builtins.length depsNames - 1)}}; do
      cp -R ''${depsPathsA[$i]} deps/''${depsNamesA[$i]}
    done
    chmod -R +w deps
    touch deps/.got
    patchShebangs .
  '';

  postInstall = ''
    sed -i \
      -e '2iexport PATH=${ctlpath}:$PATH' \
      -e 's,\(^ *FLOCK=\).*,\1${utillinux}/bin/flock,' \
      -e 's,\(^ *JOT=\).*,\1,' \
      -e 's,\(^ *CONNLOCKDIR=\).*,\1/var/lock/ejabberdctl,' \
      $out/sbin/ejabberdctl
  '';

  meta = {
    description = "Open-source XMPP application server written in Erlang";
    license = stdenv.lib.licenses.gpl2;
    homepage = http://www.ejabberd.im;
    maintainers = [ lib.maintainers.sander ];
  };
}
