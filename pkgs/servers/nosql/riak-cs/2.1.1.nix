{ stdenv, lib, fetchurl, unzip, erlang, git, wget, which, pam, coreutils, riak
, Carbon ? null, Cocoa ? null }:

stdenv.mkDerivation rec {
  name = "riak_cs-2.1.1";

  buildInputs = [
    which unzip erlang git wget
  ] ++ lib.optionals stdenv.isDarwin [ Carbon Cocoa ]
    ++ lib.optional stdenv.isLinux [ pam ];

  src = fetchurl {
    url = "http://s3.amazonaws.com/downloads.basho.com/riak-cs/2.1/2.1.1/riak-cs-2.1.1.tar.gz";
    sha256 = "115cac127aac6d759c1b429a52e0d18e491c0719a6530b1b88aa52c4efdbedd5";
  };


  postPatch = ''
    sed -i deps/node_package/priv/base/env.sh \
      -e 's@{{platform_data_dir}}@''${RIAK_DATA_DIR:-/var/db/riak-cs}@' \
      -e 's@^RUNNER_SCRIPT_DIR=.*@RUNNER_SCRIPT_DIR='$out'/bin@' \
      -e 's@^RUNNER_BASE_DIR=.*@RUNNER_BASE_DIR='$out'@' \
      -e 's@^RUNNER_ETC_DIR=.*@RUNNER_ETC_DIR=''${RIAK_ETC_DIR:-/etc/riak-cs}@' \
      -e 's@^RUNNER_LOG_DIR=.*@RUNNER_LOG_DIR=''${RIAK_LOG_DIR:-/var/log}@'

    sed -i ./Makefile \
      -e 's@rel: deps compile@rel: deps compile-src@'
  '';

  preBuild = ''
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
    mv rel/riak-cs/etc rel/riak-cs/riak-etc
    mkdir -p rel/riak-cs/etc
    mv rel/riak-cs/riak-etc rel/riak-cs/etc/riak-cs
    mv rel/riak-cs/* $out

    for prog in $out/bin/*; do
      substituteInPlace $prog \
        --replace '. "`cd \`dirname $0\` && /bin/pwd`/../lib/env.sh"' \
                  ". $out/lib/env.sh"
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "Dynamo inspired NoSQL DB by Basho with S3 compatibility";
    platforms   = [ "x86_64-linux" "x86_64-darwin" ];
    license     = licenses.asl20;
    maintainers = with maintainers; [ mdaiter ];
  };
}
