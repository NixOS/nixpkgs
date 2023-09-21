{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tun2socks";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "xjasonlyu";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qRjVZF15CjFohv9PQO0bLAjS8ip//S7yncXOn9oS2XM=";
  };

  vendorHash = "sha256-zeiOcn33PnyoseYb0wynkn7MfGp3rHEYBStY98C6aR8=";

  ldflags = [
    "-w" "-s" "-buildid="
    "-X github.com/xjasonlyu/tun2socks/v2/internal/version.Version=v${version}"
    "-X github.com/xjasonlyu/tun2socks/v2/internal/version.GitCommit=v${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/xjasonlyu/tun2socks";
    description = "tun2socks - powered by gVisor TCP/IP stack";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ nickcao ];
  };
}
