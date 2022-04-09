{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gosec";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "securego";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-AYD45L1FFT/S1toLK489C2TTasTHVXIs4Tf7TLOaye0=";
  };

  vendorSha256 = "sha256-zzbINVp8EA5aIvwUiFlQRtD6YL0iytbgVzCHbo+clYI=";

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
