{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gosec";
  version = "2.17.0";

  src = fetchFromGitHub {
    owner = "securego";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-cVW0CsVEBitSXS1Ciyt/EhE38KM7x4Up3aYUwKwrxvg=";
  };

  vendorHash = "sha256-mxSfdkqwJBUu34VWQ2Xlb2Jbz1QgWUH78Xngge9+AfA=";

  subPackages = [
    "cmd/gosec"
  ];

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
  };
}
