{ stdenv, lib, fetchurl, unzip, erlang, git, wget, which, pam 
, Carbon ? null, Cocoa ? null }:

stdenv.mkDerivation rec {
  name = "stanchion-2.1.1";

  buildInputs = [
    which unzip erlang git wget
  ] ++ lib.optionals stdenv.isDarwin [ Carbon Cocoa ]
    ++ lib.optional stdenv.isLinux [ pam ];

  src = fetchurl {
    url = "https://s3.amazonaws.com/downloads.basho.com/stanchion/2.1/2.1.1/stanchion-2.1.1.tar.gz";
    sha256 = "1443arwgg7qvlx3msyg99qvvhck7qxphdjslcp494i60fhr2g8ja";
  };


  postPatch = ''
    sed -i deps/node_package/priv/base/env.sh \
      -e 's@{{platform_data_dir}}@''${RIAK_DATA_DIR:-/var/db/stanchion}@' \
      -e 's@^RUNNER_SCRIPT_DIR=.*@RUNNER_SCRIPT_DIR='$out'/bin@' \
      -e 's@^RUNNER_BASE_DIR=.*@RUNNER_BASE_DIR='$out'@' \
      -e 's@^RUNNER_ETC_DIR=.*@RUNNER_ETC_DIR=''${RIAK_ETC_DIR:-/etc/stanchion}@' \
      -e 's@^RUNNER_LOG_DIR=.*@RUNNER_LOG_DIR=''${RIAK_LOG_DIR:-/var/log}@'
  '';

  preBuild = ''
    patchShebangs .
  '';

  buildPhase = ''
    runHook preBuild

    make rel

    runHook postBuild
  '';

  doCheck = false;

  installPhase = ''
    runHook preInstall

    mkdir $out
    mv rel/stanchion/etc rel/stanchion/riak-etc
    mkdir -p rel/stanchion/etc
    mv rel/stanchion/riak-etc rel/stanchion/etc/stanchion
    mv rel/stanchion/* $out

    for prog in $out/bin/*; do
      substituteInPlace $prog \
        --replace '. "`cd \`dirname $0\` && /bin/pwd`/../lib/env.sh"' \
                  ". $out/lib/env.sh"
    done

    runHook postInstall
  '';

  meta = with lib; {
    maintainers = with maintainers; [ mdaiter ];
    description = "Manager for Riak CS";
    platforms   = [ "x86_64-linux" "x86_64-darwin" ];
    license = licenses.asl20;
  };
}
