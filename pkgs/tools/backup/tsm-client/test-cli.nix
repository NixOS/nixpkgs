{ lib
, writeText
, runCommand
, tsm-client
}:

# Let the client try to connect to a server.
# We can't simulate a server, so there's no more to test.

let

  # 192.0.0.8 is a "dummy address" according to RFC 7600
  dsmSysCli = writeText "cli.dsm.sys" ''
    defaultserver  testserver
    server  testserver
      commmethod  v6tcpip
      tcpserveraddress  192.0.0.8
      nodename  ARBITRARYNODENAME
  '';

  tsm-client_ = tsm-client.override { inherit dsmSysCli; };

  env.nativeBuildInputs = [ tsm-client_ ];

  versionString =
    let
      inherit (tsm-client_.passthru.unwrapped) version;
      major = lib.versions.major version;
      minor = lib.versions.minor version;
      patch = lib.versions.patch version;
      fixup = lib.lists.elemAt (lib.versions.splitVersion version) 3;
    in
      "Client Version ${major}, Release ${minor}, Level ${patch}.${fixup}";

in

runCommand "${tsm-client.name}-test-cli" env ''
  set -o nounset
  set -o pipefail

  export DSM_LOG=$(mktemp -d ./dsm_log.XXXXXXXXXXX)

  { dsmc -optfile=/dev/null || true; } | tee dsmc-stdout

  # does it report the correct version?
  grep --fixed-strings '${versionString}' dsmc-stdout

  # does it use the provided dsm.sys config file?
  # if it does, it states the node's name
  grep ARBITRARYNODENAME dsmc-stdout

  # does it try (and fail) to connect to the server?
  # if it does, it reports the "TCP/IP connection failure" error code
  grep ANS1017E dsmc-stdout
  grep ANS1017E $DSM_LOG/dsmerror.log

  touch $out
''
