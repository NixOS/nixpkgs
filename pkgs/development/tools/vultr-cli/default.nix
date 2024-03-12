{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "vultr-cli";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "vultr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-d2xAM2TpnAow9n+eolEbSiKFhWRj69jHf5R+aUyoipI=";
  };

  vendorHash = "sha256-uzPEBz0LGJwHjq3yrirfp6qm8Aa94+wFSohlgBB2rEk=";

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
