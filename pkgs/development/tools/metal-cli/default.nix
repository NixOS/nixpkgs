{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "metal-cli";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "equinix";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-aZzz8KVvvhpdHAQ1QzSafc9Byu7bB9SobFjSad5RVPg=";
  };

  vendorHash = "sha256-1pVf5d05zuKmFHTdKnuDKbvKggVea0Z8vppj/hOw1rs=";

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
