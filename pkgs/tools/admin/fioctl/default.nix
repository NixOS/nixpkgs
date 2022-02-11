{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fioctl";
  version = "0.23";

  src = fetchFromGitHub {
    owner = "foundriesio";
    repo = "fioctl";
    rev = "v${version}";
    sha256 = "sha256-00HWby1LwKEz4BgwD3yv0IMW9mzkTj4FMFgYAn7kLac=";
  };

  vendorSha256 = "sha256-oA8/9LjMRM1RXKKDWhcbt2qr/4T7YgOq92U2mF9E+sw=";

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
