{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gosec";
  version = "2.13.1";

  src = fetchFromGitHub {
    owner = "securego";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-a7SZe6n3MQIjkOtFPavFYmBadHwsShjWdzMzOGZIb9s=";
  };

  vendorSha256 = "sha256-D4wWofYz63c0yXIg4xnolXzWudG17dRqdjUHYhMrtt4=";

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
    platforms = platforms.linux ++ platforms.darwin;
  };
}
