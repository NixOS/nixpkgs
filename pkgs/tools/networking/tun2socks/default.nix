{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tun2socks";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "xjasonlyu";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FBYRqxS8DJbIc8j8X6WNxl6a1YRcNrPSnNfrq/Y0fMM=";
  };

  vendorSha256 = "sha256-XWzbEtYd8h63QdpAQZTGxyxMAAnpKO9Fp4y8/eeZ7Xw=";

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
