{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "vultr-cli";
  version = "2.20.0";

  src = fetchFromGitHub {
    owner = "vultr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-3Zd507yAymmQRgybm96VD413kId0/kMxIHbmUh8j6Kk=";
  };

  vendorHash = "sha256-OVoOCExAU6cDyWhSpk4hkhBZpWehH+4/vU/X81w9XgA=";

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
