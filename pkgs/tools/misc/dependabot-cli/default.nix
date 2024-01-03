{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "dependabot-cli";
  version = "1.45.0";

  src = fetchFromGitHub {
    owner = "dependabot";
    repo = "cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-ndddBapkFwGz2TdvbQ1rM7uQze7h+8OAeB7HV3y4WwY=";
  };

  vendorHash = "sha256-Cw0LHP/7xKx7vktfL3/ytaB2vAYrHs432Llnp6Pn4QE=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/dependabot/cli/cmd/dependabot/internal/cmd.version=${version}"
  ];

  postPatch = ''
    # Requires Docker daemon
    substituteInPlace cmd/dependabot/dependabot_test.go \
      --replace "TestDependabot" "SkipDependabot"
    substituteInPlace internal/infra/run_test.go \
      --replace "TestRun" "SkipRun"
  '';

  meta = with lib; {
    description = "A tool for testing and debugging Dependabot update jobs";
    homepage = "https://github.com/dependabot/cli";
    changelog = "https://github.com/dependabot/cli/releases/tag/v${version}";
    maintainers = with maintainers; [ jamiemagee ];
    license = licenses.mit;
    mainProgram = "dependabot";
  };
}
