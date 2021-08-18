{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fioctl";
  version = "0.19.1";

  src = fetchFromGitHub {
    owner = "foundriesio";
    repo = "fioctl";
    rev = "v${version}";
    sha256 = "sha256-s6L/B01TaSCDMyRjZxNBDdhR46H7kDeXvVVP7b1e9Iw=";
  };

  vendorSha256 = "sha256-SuUY4xwinky5QO+GxyotrFiYX1LnWQNjwWXIUpfVHUE=";

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
