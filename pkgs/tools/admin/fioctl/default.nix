{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, fioctl }:

buildGoModule rec {
  pname = "fioctl";
  version = "0.38";

  src = fetchFromGitHub {
    owner = "foundriesio";
    repo = "fioctl";
    rev = "v${version}";
    sha256 = "sha256-MA7mMGZyRbQ4165qB+Q6/gQZP/yaUoZmMCVrPCPZoj4=";
  };

  vendorHash = "sha256-OmukK6ecaiCRnK6fL238GhkxW4A4yrcR/xelBZzVwqI=";

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
