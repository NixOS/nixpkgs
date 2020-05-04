{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "yggdrasil";
  version = "0.3.14";

  src = fetchFromGitHub {
    owner = "yggdrasil-network";
    repo = "yggdrasil-go";
    rev = "v${version}";
    sha256 = "147kl2kvv1rn3yk0mlvd998a2yayjl07csxxkjvs6264j6csb860";
  };

  modSha256 = "1ffp7q7kbkm1312sz6xnpc7342iczy9vj3m76lflirr1ljmw0dnb";

  # Change the default location of the management socket on Linux
  # systems so that the yggdrasil system service unit does not have to
  # be granted write permission to /run.
  patches = [ ./change-runtime-dir.patch ];

  subPackages = [ "cmd/yggdrasil" "cmd/yggdrasilctl" ];

  buildFlagsArray = ''
    -ldflags=
      -X github.com/yggdrasil-network/yggdrasil-go/src/version.buildVersion=${version}
      -X github.com/yggdrasil-network/yggdrasil-go/src/version.buildName=${pname}
      -s -w
  '';

  passthru.tests.basic = nixosTests.yggdrasil;

  meta = with lib; {
    description =
      "An experiment in scalable routing as an encrypted IPv6 overlay network";
    homepage = "https://yggdrasil-network.github.io/";
    license = licenses.lgpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ ehmry gazally lassulus ];
  };
}
