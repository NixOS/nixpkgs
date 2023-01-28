{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "auth0-cli";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "auth0";
    repo = "auth0-cli";
    rev = "v${version}";
    hash = "sha256-FotjdMbQXDwkURSeye86sIFN60V//UlF7kZrwfkvTGY=";
  };

  vendorHash = "sha256-2lu8mlADpTjp11S/chz9Ow5W5dw5l6llitJxamNiyLg=";

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
