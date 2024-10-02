{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gosec";
  version = "2.21.4";

  src = fetchFromGitHub {
    owner = "securego";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-fu0k+dZyEo2l0PWfN8iryGgUIJsWi7AQD3ku+w1tuGM=";
  };

  vendorHash = "sha256-LYEAQ/7S31Rv2gmkLReV1lKeAHW5DpKkegKb0Js75q0=";

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
    mainProgram = "gosec";
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit nilp0inter ];
  };
}
