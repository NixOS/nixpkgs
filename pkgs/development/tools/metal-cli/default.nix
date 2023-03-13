{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "metal-cli";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "equinix";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-CibqkT4YHxQ7geUKROp7SMvamN0ba/FqTXFHO1TUP/k=";
  };

  vendorHash = "sha256-4hjrKlpd+gr/yLRuSq8XrOVl76uYVIMfYjTAgqkbOSw=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/equinix/metal-cli/cmd.Version=${version}"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --cmd metal \
      --bash <($out/bin/metal completion bash) \
      --fish <($out/bin/metal completion fish) \
      --zsh <($out/bin/metal completion zsh)
  '';

  doCheck = false;

  doInstallCheck = true;

  installCheckPhase = ''
      $out/bin/metal --version | grep ${version}
  '';

  meta = with lib; {
    description = "Official Equinix Metal CLI";
    homepage = "https://github.com/equinix/metal-cli/";
    changelog = "https://github.com/equinix/metal-cli/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne nshalman ];
    mainProgram = "metal";
  };
}
