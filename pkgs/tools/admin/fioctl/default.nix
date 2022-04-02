{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fioctl";
  version = "0.24";

  src = fetchFromGitHub {
    owner = "foundriesio";
    repo = "fioctl";
    rev = "v${version}";
    sha256 = "sha256-nlSJ6JxC5MTS/ltSB9qnhtoRjDL1A5NlXWM/2A4duGU=";
  };

  vendorSha256 = "sha256-Cr9etq9E16vj2AL9OkIQom/gATjj9QT9+keUR1WQJR0=";

  ldflags = [
    "-s" "-w" "-X github.com/foundriesio/fioctl/subcommands/version.Commit=${src.rev}"
  ];

  meta = with lib; {
    description = "A simple CLI to manage your Foundries Factory ";
    homepage = "https://github.com/foundriesio/fioctl";
    license = licenses.asl20;
    maintainers = with maintainers; [ nixinator matthewcroughan ];
  };
}
