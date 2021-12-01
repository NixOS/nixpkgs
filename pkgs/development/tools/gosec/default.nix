{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gosec";
  version = "2.9.3";

  src = fetchFromGitHub {
    owner = "securego";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WjHNiFfa0YXuRq/FfWcamBwAVqRqLv9Qf+vy74rsCS4=";
  };

  vendorSha256 = "sha256-X2qxoq6bCQJH0B/jq670WWuTkDEurFI+Zx/5bcvXtVY=";

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
