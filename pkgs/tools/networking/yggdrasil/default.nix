{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "yggdrasil";
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "yggdrasil-network";
    repo = "yggdrasil-go";
    rev = "v${version}";
    sha256 = "sha256-01ciAutRIn4DmqlvDTXhRiuZHTtF8b6js7SUrLOjtAY=";
  };

  vendorSha256 = "sha256-hwDi59Yp92eMDqA8OD56nxsKSX2ngxs0lYdmEMLX+Oc=";

  # Change the default location of the management socket on Linux
  # systems so that the yggdrasil system service unit does not have to
  # be granted write permission to /run.
  patches = [ ./change-runtime-dir.patch ];

  subPackages = [ "cmd/genkeys" "cmd/yggdrasil" "cmd/yggdrasilctl" ];

  ldflags = [
    "-X github.com/yggdrasil-network/yggdrasil-go/src/version.buildVersion=${version}"
    "-X github.com/yggdrasil-network/yggdrasil-go/src/version.buildName=${pname}"
    "-s" "-w"
  ];

  passthru.tests.basic = nixosTests.yggdrasil;

  meta = with lib; {
    description =
      "An experiment in scalable routing as an encrypted IPv6 overlay network";
    homepage = "https://yggdrasil-network.github.io/";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ bbigras ehmry gazally lassulus ];
  };
}
