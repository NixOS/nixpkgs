{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "yggdrasil";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "yggdrasil-network";
    repo = "yggdrasil-go";
    rev = "v${version}";
    sha256 = "sha256-sMcbOTLdmAXp3U2XeNM0hrwOTjzr+9B6IvAaVbjhuFY=";
  };

  vendorSha256 = "sha256-QQN8ePOQ7DT9KeuY4ohFuPtocuinh3Y3us6QMnCQ4gc=";

  doCheck = false;

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
    maintainers = with maintainers; [ ehmry gazally lassulus ];
  };
}
