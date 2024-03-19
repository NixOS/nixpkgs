{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "auth0-cli";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "auth0";
    repo = "auth0-cli";
    rev = "v${version}";
    hash = "sha256-EJH+Vn7wvrQ2umjmSXHjbgf2uf/kRbDoo0usTMqDFo4=";
  };

  vendorHash = "sha256-T8y7MPFebDU6skfz4Rqo0ElRRaldtfexOl99D7h+orU=";

  ldflags = [
    "-s" "-w"
    "-X github.com/auth0/auth0-cli/internal/buildinfo.Version=v${version}"
    "-X github.com/auth0/auth0-cli/internal/buildinfo.Revision=0000000"
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
    changelog = "https://github.com/auth0/auth0-cli/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
    mainProgram = "auth0";
  };
}
