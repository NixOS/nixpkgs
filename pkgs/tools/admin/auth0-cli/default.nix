{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "auth0-cli";
  version = "0.11.10";

  src = fetchFromGitHub {
    owner = "auth0";
    repo = "auth0-cli";
    rev = "v${version}";
    hash = "sha256-1/T2hpSNamorWFuaSBoLsGpe9I06HGew9S3yJsDLmLQ=";
  };

  vendorHash = "sha256-d9ZwK/LAZGgeagGsg3bGYnVykfQcCLUex0pe/PUCtkA=";

  ldflags = [
    "-s" "-w"
    "-X github.com/auth0/auth0-cli/internal/buildinfo.Version=v${version}"
  ];

  preCheck = ''
    # Feed in all tests for testing
    # This is because subPackages above limits what is built to just what we
    # want but also limits the tests
    unset subPackages
  '';

  subPackages = [ "cmd/auth0" ];

  meta = with lib; {
    description = "Supercharge your developer workflow";
    homepage = "https://auth0.github.io/auth0-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
  };
}
