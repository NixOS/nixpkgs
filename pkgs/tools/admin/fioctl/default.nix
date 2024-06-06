{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, fioctl }:

buildGoModule rec {
  pname = "fioctl";
  version = "0.42";

  src = fetchFromGitHub {
    owner = "foundriesio";
    repo = "fioctl";
    rev = "v${version}";
    sha256 = "sha256-UqUr57D5nZh+zanzCmxujLbA8eICKx0NUlP78YH8x/Q=";
  };

  vendorHash = "sha256-A5buz9JOAiXx9X4qmi7mTMJiy/E6XBaFlG/sXOG5AKw=";

  ldflags = [
    "-s" "-w"
    "-X github.com/foundriesio/fioctl/subcommands/version.Commit=${src.rev}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd fioctl \
      --bash <($out/bin/fioctl completion bash) \
      --fish <($out/bin/fioctl completion fish) \
      --zsh <($out/bin/fioctl completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = fioctl;
    command = "HOME=$(mktemp -d) fioctl version";
    version = "v${version}";
  };

  meta = with lib; {
    description = "A simple CLI to manage your Foundries Factory";
    homepage = "https://github.com/foundriesio/fioctl";
    license = licenses.asl20;
    maintainers = with maintainers; [ nixinator matthewcroughan ];
    mainProgram = "fioctl";
  };
}
