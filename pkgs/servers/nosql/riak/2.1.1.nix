{ stdenv, lib, fetchurl, unzip, erlangR16, which, pam, coreutils }:

let
  solrName = "solr-4.7.0-yz-1.tgz";
  yokozunaJarName = "yokozuna-2.jar";
  yzMonitorJarName = "yz_monitor-1.jar";

  srcs = {
    riak = fetchurl {
      url = "http://s3.amazonaws.com/downloads.basho.com/riak/2.1/2.1.1/riak-2.1.1.tar.gz";
      sha256 = "1bm5j3zknz82mkyh5zgaap73awflh4mkibdvdz164235mdxlwhdm";
    };
    solr = fetchurl {
      url = "http://s3.amazonaws.com/files.basho.com/solr/${solrName}";
      sha256 = "0brml3lb3xk26rmi05rrzpxrw92alfi9gi7p7537ny9lqg3808qp";
    };
    yokozunaJar = fetchurl {
      url = "http://s3.amazonaws.com/files.basho.com/yokozuna/${yokozunaJarName}";
      sha256 = "0xzfy181qxv27pc4f5xd0szn8vls5743273awr5rwv3608gkspj2";
    };
    yzMonitorJar = fetchurl {
      url = "http://s3.amazonaws.com/files.basho.com/yokozuna/${yzMonitorJarName}";
      sha256 = "0kb97d1a43vw759j1h5qwbhx455pidn2pi7sfxijqic37h81ri1m";
    };
  };
in

stdenv.mkDerivation rec {
  name = "riak-2.1.1";

  buildInputs = [
    which unzip erlangR16 pam
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

  meta = with lib; {
    maintainers = with maintainers; [ cstrahan ];
    description = "Dynamo inspired NoSQL DB by Basho";
    platforms   = [ "x86_64-linux" ];
  };
}
