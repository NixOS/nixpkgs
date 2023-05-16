{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, fioctl }:

buildGoModule rec {
  pname = "fioctl";
<<<<<<< HEAD
  version = "0.35";
=======
  version = "0.32.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "foundriesio";
    repo = "fioctl";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-4lAoUmbNsC0d+yaB+DqHVqz3UMI08rhXIm7rgueeXik=";
=======
    sha256 = "sha256-3k3FoRU1yCtntVe3WTGUuhIBTD6KRvSsDISbjmNvzQI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = "sha256-hSllpWjiYOBbANCX7usdAAF1HNAJ79ELK92qEyn8G1c=";

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
  };
}
