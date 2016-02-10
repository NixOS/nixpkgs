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
    #! ${stdenv.shell} -e
    if [ "$1" = "describe" ]; then
      [ -r .rev ] && cat .rev || true
    fi
  '';

  # These can be extracted from `rebar.config`
  # Some dependencies are from another packages. Try commenting them out; then during build
  # you'll get necessary revision information.
  ejdeps = {
    cache_tab = fetchFromGitHub {
      owner = "processone";
      repo = "cache_tab";
      rev = "1.0.1";
      sha256 = "1mq5vgqskb0v2pdn6i3610hzd9iyjznh8143pdbz8z57rrhxpxg4";
    };
    p1_tls = fetchFromGitHub {
      owner = "processone";
      repo = "tls";
      rev = "1.0.0";
      sha256 = "1q6l5drgmwj4fp4nfh0075lczplia4n40sirk9pd5x76d59qcmnj";
    };
    p1_stringprep = fetchFromGitHub {
      owner = "processone";
      repo = "stringprep";
      rev = "1.0.0";
      sha256 = "105xc0af61xrd4vjxrg49gxbij8x0fq4yribywa8qly303d1nwwa";
    };
    p1_xml = fetchFromGitHub {
      owner = "processone";
      repo = "xml";
      rev = "1.1.1";
      sha256 = "07zxc8ky78sd2mcbhhrxha68arbbk8vyayn9gwi402avnqcic7cx";
    };
    esip = fetchFromGitHub {
      owner = "processone";
      repo = "p1_sip";
      rev = "1.0.0";
      sha256 = "02k920995b0js6srarx0rabavs428rl0dp7zz90x74l8b589zq9a";
    };
    p1_stun = fetchFromGitHub {
      owner = "processone";
      repo = "stun";
      rev = "0.9.0";
      sha256 = "0ghf2p6z1m55f5pm4pv5gj7h7fdcwcsyqz1wzax4w8bgs9id06dm";
    };
    p1_yaml = fetchFromGitHub {
      owner = "processone";
      repo = "p1_yaml";
      rev = "1.0.0";
      sha256 = "0is0vr8ygh3fbiyf0jb85cfpfakxmx31fqk6s4j90gmfhlbm16f8";
    };
    p1_utils = fetchFromGitHub {
      owner = "processone";
      repo = "p1_utils";
      rev = "1.0.2";
      sha256 = "11b71bnc90riy1qplkpwx6l1yr9849jai3ckri35cavfsk35j687";
    };
    jiffy = fetchFromGitHub {
      owner = "davisp";
      repo = "jiffy";
      rev = "0.14.5";
      sha256 = "1xs01cl4gq1x6sjj7d1qgg4iq9iwzv3cjqjrj0kr7rqrbfqx2nq3";
    };
    oauth2 = fetchFromGitHub {
      owner = "kivra";
      repo = "oauth2";
      rev = "8d129fbf8866930b4ffa6dd84e65bd2b32b9acb8";
      sha256 = "0mbmw6668l945iqppba991793nmmkyvvf18zxgdahxcwgxg1majn";
    };
    xmlrpc = fetchFromGitHub {
      owner = "rds13";
      repo = "xmlrpc";
      rev = "1.15";
      sha256 = "0ihwag2hgw9rswxygallc4w1yipgpd6arw3xpr799ib7ybsn8x81";
    };

    p1_mysql = fetchFromGitHub {
      owner = "processone";
      repo = "mysql";
      rev = "1.0.0";
      sha256 = "1v3g75hhfpv5bnrar23y7lsk3pd02xl5cy4mj13j0qxl6bc4dgss";
    };
    p1_pgsql = fetchFromGitHub {
      owner = "processone";
      repo = "pgsql";
      rev = "1.0.0";
      sha256 = "1r7dkjzxhwplmhvgvdx990xn98gpslckah5jpkx8c2gm9nj3xi33";
    };
    sqlite3 = fetchFromGitHub {
      owner = "alexeyr";
      repo = "erlang-sqlite3";
      rev = "cbc3505f7a131254265d3ef56191b2581b8cc172";
      sha256 = "1xrvygv0zhslsqf8044m5ml1zr6di7znvv2zycg3amsz190w0w2g";
    };
    p1_pam = fetchFromGitHub {
      owner = "processone";
      repo = "epam";
      rev = "1.0.0";
      sha256 = "0dlbmfwndhyg855vnhwyccxcjqzf2wcgc7522mjb9q38cva50rpr";
    };
    p1_zlib = fetchFromGitHub {
      owner = "processone";
      repo = "zlib";
      rev = "1.0.0";
      sha256 = "1a6m7wz6cbb8526fwhmgm7mva62absmvyjm8cjnq7cs0mzp18r0m";
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
    rebar_elixir_plugin = fetchFromGitHub {
      owner = "processone";
      repo = "rebar_elixir_plugin";
      rev = "0.1.0";
      sha256 = "0x04ff53mxwd9va8nl4m70dbamp6p4dpxs646c168iqpnpadk3sk";
    };
    elixir = fetchFromGitHub {
      owner = "elixir-lang";
      repo = "elixir";
      rev = "v1.1.0";
      sha256 = "0r5673x2qdvfbwmvyvj8ddvzgxnkl3cv9jsf1yzsxgdifjbrzwx7";
    };
    p1_iconv = fetchFromGitHub {
      owner = "processone";
      repo = "eiconv";
      rev = "0.9.0";
      sha256 = "1ikccpj3aq6mip6slrq8c7w3kilpb82dr1jdy8kwajmiy9cmsq97";
    };
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
    p1_logger = fetchFromGitHub {
      owner = "processone";
      repo = "p1_logger";
      rev = "1.0.0";
      sha256 = "0z11xsr139a75w09syjws4sja6ky2l9rsrwkjr6wcl7p1jz02h4r";
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
  version = "16.01";
  name = "ejabberd-${version}";

  src = fetchurl {
    url = "http://www.process-one.net/downloads/ejabberd/${version}/${name}.tgz";
    sha256 = "10fnsw52gxybw731yka63ma8mj39g4i0nsancwp9nlvhb2flgk72";
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
    [ "cache_tab" "p1_tls" "p1_stringprep" "p1_xml" "esip" "p1_stun" "p1_yaml" "p1_utils" "jiffy" "oauth2" "xmlrpc" ]
    ++ lib.optional withMysql "p1_mysql"
    ++ lib.optional withPgsql "p1_pgsql"
    ++ lib.optional withSqlite "sqlite3"
    ++ lib.optional withPam "p1_pam"
    ++ lib.optional withZlib "p1_zlib"
    ++ lib.optionals withRiak [ "hamcrest" "riakc" "riak_pb" "protobuffs" ]
    ++ lib.optionals withElixir [ "rebar_elixir_plugin" "elixir" ]
    ++ lib.optional withIconv "p1_iconv"
    ++ lib.optionals withLager [ "lager" "goldrush" ]
    ++ lib.optional (!withLager) "p1_logger"
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
      (lib.enableFeature withLager "lager")
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
    license = stdenv.lib.licenses.gpl2;
    homepage = http://www.ejabberd.im;
    maintainers = [ lib.maintainers.sander ];
  };
}
