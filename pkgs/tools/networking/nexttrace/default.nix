{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nexttrace";
  version = "1.1.7-1";

  src = fetchFromGitHub {
    owner = "sjlleo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ZMbX37gi9aGamDtoTdfUMiCPieP4DhjBSE5CIJLK6Z0=";
  };
  vendorHash = "sha256-u5EIzYWr81tmMmImoRH0wT7aD3/0tx+W3CXeymWVACM=";

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

