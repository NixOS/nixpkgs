{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fioctl";
  version = "0.18";

  src = fetchFromGitHub {
    owner = "foundriesio";
    repo = "fioctl";
    rev = "v${version}";
    sha256 = "sha256-uqJ08ftaU39gmhDtl+noVtGscu6utcl42rXz4XaGtWc=";
  };

  vendorSha256 = "sha256-6a+JMj3hh6GPuqnLknv7/uR8vsUsOgsS+pdxHoMqH5w=";

  runVend = true;

  buildFlagsArray = ''
    -ldflags=-s -w -X github.com/foundriesio/fioctl/subcommands/version.Commit=${src.rev}
  '';

  meta = with lib; {
    description = "A simple CLI to manage your Foundries Factory ";
    homepage = "https://github.com/foundriesio/fioctl";
    license = licenses.asl20;
    maintainers = with maintainers; [ nixinator matthewcroughan ];
  };
}
