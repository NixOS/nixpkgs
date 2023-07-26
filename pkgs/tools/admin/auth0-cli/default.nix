{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "auth0-cli";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "auth0";
    repo = "auth0-cli";
    rev = "v${version}";
    hash = "sha256-mOG7N7+qmAw+D6Bp0QtyS3oualDD/fffDVCuidLJ+Pw=";
  };

  vendorHash = "sha256-8t5qnHaZeZUxdk5DmIfOx86Zk9c9hJuxHjE6upqC638=";

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
