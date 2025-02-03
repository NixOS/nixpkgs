{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gosec";
  version = "2.21.2";

  src = fetchFromGitHub {
    owner = "securego";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-1lVyIytIorxxipDZAf2AYqtO1Slz9aUw6MpC40ji89w=";
  };

  vendorHash = "sha256-jxbGAEvkjvuK878nkl8TGbZmBzS7n9nG4hH9BL3UGwE=";

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
