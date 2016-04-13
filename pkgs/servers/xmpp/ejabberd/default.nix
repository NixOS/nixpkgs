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
, withTools ? false
, withRedis ? false
}:

let
  ctlpath = lib.makeBinPath [ bash gnused gnugrep coreutils utillinux procps ];

  fakegit = writeScriptBin "git" ''
    #! ${stdenv.shell} -e
    if [ "$1" = "describe" ]; then
      [ -r .rev ] && cat .rev || true
    fi
  '';

  # These can be extracted from `rebar.config`
  # Some dependencies are from another packages. Try commenting them out; then during build
  # you'll get necessary revision information.
  ejdeps = {
    lager = fetchFromGitHub {
      owner = "basho";
      repo = "lager";
      rev = "3.0.2";
      sha256 = "04l40dlqpl2y6ddpbpknmnjf537bjvrmg8r0jnmw1h60dgyb2ydk";
    };
    # dependency of lager
    goldrush = fetchFromGitHub {
      owner = "DeadZen";
      repo = "goldrush";
      rev = "0.1.7";
      sha256 = "1104j8v86hdavxf08yjyjkpi5vf95rfvsywdx29c69x3z33i4z3m";
    };
    p1_utils = fetchFromGitHub {
      owner = "processone";
      repo = "p1_utils";
      rev = "1.0.3";
      sha256 = "0bw163wx0ji2sz7yb3nzvm1mnnljsdji606xzk33za8c4sgrb4nj";
    };
    cache_tab = fetchFromGitHub {
      owner = "processone";
      repo = "cache_tab";
      rev = "1.0.2";
      sha256 = "1krgn6y95jgc8pc0vkj36p0wcazsb8b6h1x4f0r1936jff2vqk33";
    };
    fast_tls = fetchFromGitHub {
      owner = "processone";
      repo = "fast_tls";
      rev = "1.0.1";
      sha256 = "08lh6935k590hix3z69kjjd75w68vmmjcx7gi4zh8j7li4v9k9l2";
    };
    stringprep = fetchFromGitHub {
      owner = "processone";
      repo = "stringprep";
      rev = "1.0.2";
      sha256 = "1wrisajyll45wf6cz1rb2q70sz83i6nfnfiijsbzhy0xk51436sa";
    };
    fast_xml = fetchFromGitHub {
      owner = "processone";
      repo = "fast_xml";
      rev = "1.1.3";
      sha256 = "1a2k21fqz8rp4laz7wn0hsxy58i1gdwc3qhw3k2kar8lgw4m3wqp";
    };
    stun = fetchFromGitHub {
      owner = "processone";
      repo = "stun";
      rev = "1.0.1";
      sha256 = "0bq0qkc7h3nhqxa6ff2nf6bi4kiax4208716hxfz6l1vxrh7f3p2";
    };
    esip = fetchFromGitHub {
      owner = "processone";
      repo = "esip";
      rev = "1.0.2";
      sha256 = "0ibvb85wkqw81y154bagp0kgf1jmdscmfq8yk73j1k986dmiqfn2";
    };
    fast_yaml = fetchFromGitHub {
      owner = "processone";
      repo = "fast_yaml";
      rev = "1.0.2";
      sha256 = "019imn255bkkvilg4nrcidl8w6dn2jrb2nyrs2nixsgcbmvkdl5k";
    };
    jiffy = fetchFromGitHub {
      owner = "davisp";
      repo = "jiffy";
      rev = "0.14.7";
      sha256 = "1w55vwz4a94v0aajm3lg6nlhpw2w0zdddiw36f2n4sfhbqn0v0jr";
    };
    p1_oauth2 = fetchFromGitHub {
      owner = "processone";
      repo = "p1_oauth2";
      rev = "0.6.1";
      sha256 = "1wvmi3fj05hlbi3sbqpakznq70n76a7nbvbrjhr8k79bmvsh6lyl";
    };
    p1_xmlrpc = fetchFromGitHub {
      owner = "processone";
      repo = "p1_xmlrpc";
      rev = "1.15.1";
      sha256 = "12pfvb3k9alzg7qbph3bc1sw7wk86psm3jrdrfclq90zlpwqa0w3";
    };
    luerl = fetchFromGitHub {
      owner = "rvirding";
      repo = "luerl";
      rev = "9524d0309a88b7c62ae93da0b632b185de3ba9db";
      sha256 = "15yplmv2xybnz3nby940752jw672vj99l1j61rrfy686hgrfnc42";
    };

    p1_mysql = fetchFromGitHub {
      owner = "processone";
      repo = "p1_mysql";
      rev = "1.0.1";
      sha256 = "17122xhc420kqfsv4c4g0jcllpdbhg84wdlwd3227w4q729jg6bk";
    };
    p1_pgsql = fetchFromGitHub {
      owner = "processone";
      repo = "p1_pgsql";
      rev = "1.0.1";
      sha256 = "1ca0hhxyfmwjp49zjga1fdhrbaqnxdpmcvs2i6nz6jmapik788nr";
    };
    sqlite3 = fetchFromGitHub {
      owner = "processone";
      repo = "erlang-sqlite3";
      rev = "1.1.5";
      sha256 = "17n4clysg540nx9g8k8mi9l7vkz8wigycgxmzzn0wmgxdf6mhxlb";
    };
    p1_pam = fetchFromGitHub {
      owner = "processone";
      repo = "epam";
      rev = "1.0.0";
      sha256 = "0dlbmfwndhyg855vnhwyccxcjqzf2wcgc7522mjb9q38cva50rpr";
    };
    ezlib = fetchFromGitHub {
      owner = "processone";
      repo = "ezlib";
      rev = "1.0.1";
      sha256 = "1asp7s2q72iql870igc827dvi9iqyd6lhs0q3jbjj2w7xfz4x4kk";
    };
    hamcrest = fetchFromGitHub {
      owner = "hyperthunk";
      repo = "hamcrest-erlang";
      rev = "908a24fda4a46776a5135db60ca071e3d783f9f6";
      sha256 = "0irxidwrb37m0xwls6q9nn2zfs3pyxrgbnjgrhnh7gm35ib51hkj";
    };
    riakc = fetchFromGitHub {
      owner = "basho";
      repo = "riak-erlang-client";
      rev = "527722d12d0433b837cdb92a60900c2cb5df8942";
      sha256 = "13rkwibsjsl2gdysvf11r1hqfrf89hjgpa0x0hz2910f2ryqll3y";
    };
    # dependency of riakc
    riak_pb = fetchFromGitHub {
      owner = "basho";
      repo = "riak_pb";
      rev = "2.1.0.7";
      sha256 = "1p0qmjq069f7j1m29dv36ayvz8m0pcm94ccsnv5blykfg2c5ja0c";
    };
    # dependency of riak_pb
    protobuffs = fetchFromGitHub {
      owner = "basho";
      repo = "erlang_protobuffs";
      rev = "0.8.2";
      sha256 = "0w4jmsnc9x2ykqh1q6b12pl8a9973dxdhqk3y0ph17n83q5xz3h7";
    };
    elixir = fetchFromGitHub {
      owner = "elixir-lang";
      repo = "elixir";
      rev = "v1.1.0";
      sha256 = "0r5673x2qdvfbwmvyvj8ddvzgxnkl3cv9jsf1yzsxgdifjbrzwx7";
    };
    rebar_elixir_plugin = fetchFromGitHub {
      owner = "processone";
      repo = "rebar_elixir_plugin";
      rev = "0.1.0";
      sha256 = "0x04ff53mxwd9va8nl4m70dbamp6p4dpxs646c168iqpnpadk3sk";
    };
    iconv = fetchFromGitHub {
      owner = "processone";
      repo = "iconv";
      rev = "1.0.0";
      sha256 = "0dfc23m2lqilj8ixn23wpj5xp1mgajb9b5ch95riigxzxmx97ri9";
    };
    meck = fetchFromGitHub {
      owner = "eproxus";
      repo = "meck";
      rev = "0.8.2";
      sha256 = "0s4qbvryap46cz63awpbv5zzmlcay5pn2lixgmgvcjarqv70cbs7";
    };
    eredis = fetchFromGitHub {
      owner = "wooga";
      repo = "eredis";
      rev = "v1.0.8";
      sha256 = "10fr3kbc2nd2liggsq4y77nfirndzapcxzkjgyp06bpr9cjlvhlm";
    };

  };

in stdenv.mkDerivation rec {
  version = "16.02";
  name = "ejabberd-${version}";

  src = fetchurl {
    url = "http://www.process-one.net/downloads/ejabberd/${version}/${name}.tgz";
    sha256 = "0yiai7zyjdcp0ppc5l5p56bxhg273hwfbv41qlbkg32dhr880f4q";
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
    [ "lager" "goldrush" "p1_utils" "cache_tab" "fast_tls" "stringprep" "fast_xml" "stun" "esip" "fast_yaml"
      "jiffy" "p1_oauth2" "p1_xmlrpc" "luerl"
    ]
    ++ lib.optional withMysql "p1_mysql"
    ++ lib.optional withPgsql "p1_pgsql"
    ++ lib.optional withSqlite "sqlite3"
    ++ lib.optional withPam "p1_pam"
    ++ lib.optional withZlib "ezlib"
    ++ lib.optionals withRiak [ "hamcrest" "riakc" "riak_pb" "protobuffs" ]
    ++ lib.optionals withElixir [ "elixir" "rebar_elixir_plugin" ]
    ++ lib.optional withIconv "iconv"
    ++ lib.optional withTools "meck"
    ++ lib.optional withRedis "eredis"
  ;

  configureFlags =
    [ (lib.enableFeature withMysql "mysql")
      (lib.enableFeature withPgsql "pgsql")
      (lib.enableFeature withSqlite "sqlite")
      (lib.enableFeature withPam "pam")
      (lib.enableFeature withZlib "zlib")
      (lib.enableFeature withRiak "riak")
      (lib.enableFeature withElixir "elixir")
      (lib.enableFeature withIconv "iconv")
      (lib.enableFeature withTools "tools")
      (lib.enableFeature withRedis "redis")
    ] ++ lib.optional withSqlite "--with-sqlite3=${sqlite}";

  depsPaths = map (x: builtins.getAttr x ejdeps) depsNames;
  depsRevs = map (x: x.rev) depsPaths;

  enableParallelBuilding = true;

  preBuild = ''
    mkdir deps
    depsPathsA=( $depsPaths )
    depsNamesA=( $depsNames )
    depsRevsA=( $depsRevs )
    for i in {0..${toString (builtins.length depsNames - 1)}}; do
      path="deps/''${depsNamesA[$i]}"
      cp -R ''${depsPathsA[$i]} "$path"
      chmod -R +w "$path"
      echo "''${depsRevsA[$i]}" > "$path/.rev"
    done
    touch deps/.got
    patchShebangs .

    for i in deps/*; do
      [ -x "$i/configure" ] && ( cd "$i"; ./configure ) || true
    done
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
    license = lib.licenses.gpl2;
    homepage = http://www.ejabberd.im;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.sander lib.maintainers.abbradar ];
  };
}
