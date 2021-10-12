{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fioctl";
  version = "0.20";

  src = fetchFromGitHub {
    owner = "foundriesio";
    repo = "fioctl";
    rev = "v${version}";
    sha256 = "sha256-vc+V69cyJZSJa6GXUUNYeXdKvmUrVIQhsBykptcl85s=";
  };

  vendorSha256 = "sha256-SuUY4xwinky5QO+GxyotrFiYX1LnWQNjwWXIUpfVHUE=";

  runVend = true;

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
