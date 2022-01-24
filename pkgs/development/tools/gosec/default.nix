{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gosec";
  version = "2.9.6";

  src = fetchFromGitHub {
    owner = "securego";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-eDzLVoOPYm8WG07dfi6s+xtBliCwf1LXoHxQ10YWs1A=";
  };

  vendorSha256 = "sha256-ELfbdrMMeK6ZG+hnibhHNB+k/Zvkepl+cbUx+E/Dvr8=";

  subPackages = [
    "cmd/gosec"
  ];

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
    "-X main.GitTag=${src.rev}"
    "-X main.BuildDate=unknown"
  ];

  meta = with lib; {
    homepage = "https://github.com/securego/gosec";
    description = "Golang security checker";
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit nilp0inter ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
