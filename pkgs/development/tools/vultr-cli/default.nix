{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "vultr-cli";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "vultr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-9akEDsBj2EpZtUBh0+Dck5otsmFzdvJshXxOtYVdi1o=";
  };

  vendorHash = "sha256-jkl36S7h1l6FeeHEhc+PKOQO9Uq/4L5wTb8+PhG2exY=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-s" "-w" ];

  postInstall = ''
    installShellCompletion --cmd vultr-cli \
      --bash <($out/bin/vultr-cli completion bash) \
      --fish <($out/bin/vultr-cli completion fish) \
      --zsh <($out/bin/vultr-cli completion zsh)
  '';

  meta = with lib; {
    description = "Official command line tool for Vultr services";
    homepage = "https://github.com/vultr/vultr-cli";
    changelog = "https://github.com/vultr/vultr-cli/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ Br1ght0ne ];
    mainProgram = "vultr-cli";
  };
}
