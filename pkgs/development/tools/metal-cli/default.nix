{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "metal-cli";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "equinix";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-O/SO4cHcENiecbZoMLNTnT4uQR8NF0N9Xq0pBCwbdy8=";
  };

  vendorHash = "sha256-cq0OH+YeEvflpEfMu3PGumhtbDSmLjAkTYas4m4UVfA=";

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
