{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "topicctl";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = "topicctl";
    rev = "v${version}";
    sha256 = "sha256-eHFqczZtJWcZ4ZVOzpCUlVoCJ7wjyWNpFfiZ9MaJHOI=";
  };

  vendorSha256 = "sha256-50UDRf8S9Yl0zwGOrFLa5L1TmSKF4RQ/ju0tnFzs56M=";

  ldflags = [
    "-X main.BuildVersion=${version}"
    "-X main.BuildCommitSha=unknown"
    "-X main.BuildDate=unknown"
  ];

  # needs a kafka server
  doCheck = false;

  meta = with lib; {
    description = "A tool for easy, declarative management of Kafka topics";
    inherit (src.meta) homepage;
    license = licenses.mit;
    maintainers = with maintainers; [ eskytthe srhb ];
  };
}
