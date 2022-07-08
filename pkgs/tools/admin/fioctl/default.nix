{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fioctl";
  version = "0.26";

  src = fetchFromGitHub {
    owner = "foundriesio";
    repo = "fioctl";
    rev = "v${version}";
    sha256 = "sha256-IrbzWQEtCEG2UUkExWgs7A81RiJLXDAOrr8q4mPwcOI=";
  };

  vendorSha256 = "sha256-lstUcyxDVcUtgVY5y5EGgSFZgHbchQ9izf8sCq5vTVQ=";

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
