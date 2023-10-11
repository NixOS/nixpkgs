{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nexttrace";
  version = "1.2.2.2";

  src = fetchFromGitHub {
    owner = "sjlleo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-a9l6nsrbgwmk6cq/rPBwPwZ8yhH35VxKmn9x5PgcqGI=";
  };
  vendorHash = "sha256-YAmGvmHkR1G2MLlDja5aPJqX2F3etogebasqD72YJ3M=";

  doCheck = false; # Tests require a network connection.

  ldflags = [
    "-s"
    "-w"
    "-X github.com/xgadget-lab/nexttrace/config.Version=v${version}"
  ];

  meta = with lib; {
    description = "An open source visual route tracking CLI tool";
    homepage = "https://mtr.moe";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ sharzy ];
  };
}

