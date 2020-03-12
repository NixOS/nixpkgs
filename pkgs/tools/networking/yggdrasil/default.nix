{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "yggdrasil";
  version = "0.3.13";

  src = fetchFromGitHub {
    owner = "yggdrasil-network";
    repo = "yggdrasil-go";
    rev = "v${version}";
    sha256 = "1k3xxarrl33sxik1dqahfllrhd501xqq5q5mcn4y5wi9lwywsy50";
  };

  modSha256 = "057yl3i29kwpd129aa2rb67s5rmz898fi2a7lxv3nfjp7018s9qw";

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

  meta = with lib; {
    description =
      "An experiment in scalable routing as an encrypted IPv6 overlay network";
    homepage = "https://yggdrasil-network.github.io/";
    license = licenses.lgpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ ehmry gazally lassulus ];
  };
}
