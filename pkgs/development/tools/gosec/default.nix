{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gosec";
  version = "2.9.5";

  src = fetchFromGitHub {
    owner = "securego";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-YXAUDICQhZFeafP/wezd+dLpXpd7waz3wUCVCwVb12I=";
  };

  vendorSha256 = "sha256-Mob8XxTALtuG9q7gMWKvp1k2cUDKI0QHAeXfQK47NDo=";

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
