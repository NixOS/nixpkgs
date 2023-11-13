{ lib
, buildGoModule
, fetchFromGitHub
, testers
, woodpecker-plugin-git
}:

buildGoModule rec {
  pname = "woodpecker-plugin-git";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "woodpecker-ci";
    repo = "plugin-git";
    rev = "refs/tags/${version}";
    hash = "sha256-siPLI463qUQs9tBMlmrMv6G5ry0JrEEIelpid9/cf88=";
  };

  vendorHash = "sha256-ol5k37gGFsyeEnGOVcJaerkIejShHyNCBu4RZ8WyHvU=";

  CGO_ENABLED = "0";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  # Checks fail because they require network access.
  doCheck = false;

  passthru.tests.version = testers.testVersion { package = woodpecker-plugin-git; };

  meta = with lib; {
    description = "Woodpecker plugin for cloning Git repositories.";
    homepage = "https://woodpecker-ci.org/";
    changelog = "https://github.com/woodpecker-ci/plugin-git/releases/tag/${version}";
    license = licenses.asl20;
    mainProgram = "plugin-git";
    maintainers = with maintainers; [ ambroisie ];
  };
}
