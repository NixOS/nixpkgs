{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tun2socks";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "xjasonlyu";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-uu0FBhckZ06eXEEuKwN3MopGMDbMjjcABYa/lgM48n4=";
  };

  vendorHash = "sha256-QIXgRoxmJaeYGx77EB53zIb94InlQbUSOXE+cUdBttI=";

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
