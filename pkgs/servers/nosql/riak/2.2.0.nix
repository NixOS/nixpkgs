{ stdenv, lib, fetchurl, unzip, erlang, which, pam, nixosTests }:

let
  solrName = "solr-4.10.4-yz-2.tgz";
  yokozunaJarName = "yokozuna-3.jar";
  yzMonitorJarName = "yz_monitor-1.jar";

  srcs = {
    riak = fetchurl {
      url = "https://s3.amazonaws.com/downloads.basho.com/riak/2.2/2.2.0/riak-2.2.0.tar.gz";
      sha256 = "0kl28bpyzajcllybili46jfr1schl45w5ysii187jr0ssgls2c9p";
    };
    solr = fetchurl {
      url = "http://s3.amazonaws.com/files.basho.com/solr/${solrName}";
      sha256 = "0fy5slnldn628gmr2kilyx606ph0iykf7pz6j0xjcc3wqvrixa2a";
    };
    yokozunaJar = fetchurl {
      url = "http://s3.amazonaws.com/files.basho.com/yokozuna/${yokozunaJarName}";
      sha256 = "17n6m100fz8affdcxsn4niw2lrpnswgfnd6aszgzipffwbg7v8v5";
    };
    yzMonitorJar = fetchurl {
      url = "http://s3.amazonaws.com/files.basho.com/yokozuna/${yzMonitorJarName}";
      sha256 = "0kb97d1a43vw759j1h5qwbhx455pidn2pi7sfxijqic37h81ri1m";
    };
  };
in

stdenv.mkDerivation {
  pname = "riak";
  version = "2.2.0";

  nativeBuildInputs = [ unzip ];
  buildInputs = [
    which erlang pam
  ];

  src = srcs.riak;

  hardeningDisable = [ "format" ];

  postPatch = ''
    sed -i deps/node_package/priv/base/env.sh \
      -e 's@{{platform_data_dir}}@''${RIAK_DATA_DIR:-/var/db/riak}@' \
      -e 's@^RUNNER_SCRIPT_DIR=.*@RUNNER_SCRIPT_DIR='$out'/bin@' \
      -e 's@^RUNNER_BASE_DIR=.*@RUNNER_BASE_DIR='$out'@' \
      -e 's@^RUNNER_ETC_DIR=.*@RUNNER_ETC_DIR=''${RIAK_ETC_DIR:-/etc/riak}@' \
      -e 's@^RUNNER_LOG_DIR=.*@RUNNER_LOG_DIR=''${RIAK_LOG_DIR:-/var/log}@'
  '';

  preBuild = ''
    mkdir solr-pkg
    cp ${srcs.solr} solr-pkg/${solrName}
    export SOLR_PKG_DIR=$(readlink -f solr-pkg)

    mkdir -p deps/yokozuna/priv/java_lib
    cp ${srcs.yokozunaJar} deps/yokozuna/priv/java_lib/${yokozunaJarName}

    mkdir -p deps/yokozuna/priv/solr/lib/ext
    cp ${srcs.yzMonitorJar} deps/yokozuna/priv/solr/lib/ext/${yzMonitorJarName}

    patchShebangs .
  '';

  buildPhase = ''
    runHook preBuild

    make locked-deps
    make rel

    runHook postBuild
  '';

  doCheck = false;

  installPhase = ''
    runHook preInstall

    mkdir $out
    mv rel/riak/etc rel/riak/riak-etc
    mkdir -p rel/riak/etc
    mv rel/riak/riak-etc rel/riak/etc/riak
    mv rel/riak/* $out

    for prog in $out/bin/*; do
      substituteInPlace $prog \
        --replace '. "`cd \`dirname $0\` && /bin/pwd`/../lib/env.sh"' \
                  ". $out/lib/env.sh"
    done

    runHook postInstall
  '';

  passthru.tests = { inherit (nixosTests) riak; };

  meta = with lib; {
    maintainers = with maintainers; [ cstrahan mdaiter ];
    description = "Dynamo inspired NoSQL DB by Basho";
    platforms   = [ "x86_64-linux" ];
    license     = licenses.asl20;
    knownVulnerabilities = [ "CVE-2017-3163 - see https://github.com/NixOS/nixpkgs/issues/33876" ];
  };
}
