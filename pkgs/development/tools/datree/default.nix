{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "datree";
  version = "0.14.95";

  src = fetchFromGitHub {
    owner = "datreeio";
    repo = "datree";
    rev = version;
    sha256 = "sha256-s204M7HReQabtSuwNumhA6YechOM7Bh3LdQJE5vs1PU=";
  };

  vendorSha256 = "sha256-SlU1lJcKCDkoihU19c8iky3Bj5ZZD9E9W0QQX9fBT1c=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/datreeio/datree/cmd.CliVersion=${version}"
  ];

  doCheck = true;

  meta = with lib; {
    description = "CLI tool to ensure K8s manifests and Helm charts follow best practices as well as your organization’s policies";
    homepage = "https://datree.io/";
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.jceb ];
  };
}
