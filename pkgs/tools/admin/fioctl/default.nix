{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fioctl";
  version = "0.15";

  src = fetchFromGitHub {
    owner = "foundriesio";
    repo = "fioctl";
    rev = "v${version}";
    sha256 = "0gmh32h9j6wpkdxxg7vj158lsaxq30x7hjsc9gwpip3bff278hw4";
  };

  vendorSha256 = "170z5a1iwwcpz890nficqnz7rr7yzdxr5jx9pa7s31z17lr8kbz9";

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
