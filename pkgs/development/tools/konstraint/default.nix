{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "konstraint";
  version = "0.36.0";

  src = fetchFromGitHub {
    owner = "plexsystems";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-GQ79xsvlRDwrthtYgykwAJLP9rkk5iNHGelWAQzOZoA=";
  };
  vendorHash = "sha256-EBlJCcF8UcstaD1ztaAFL4MSfBOYvpeUygzXnQbW8N8=";

  # Exclude go within .github folder
  excludedPackages = ".github";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/plexsystems/konstraint/internal/commands.version=${version}"
  ];

  postInstall = ''
    installShellCompletion --cmd konstraint \
      --bash <($out/bin/konstraint completion bash) \
      --fish <($out/bin/konstraint completion fish) \
      --zsh <($out/bin/konstraint completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/konstraint --help
    $out/bin/konstraint --version | grep "${version}"
    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/plexsystems/konstraint";
    changelog = "https://github.com/plexsystems/konstraint/releases/tag/v${version}";
    description = "A policy management tool for interacting with Gatekeeper";
    mainProgram = "konstraint";
    longDescription = ''
      konstraint is a CLI tool to assist with the creation and management of templates and constraints when using
      Gatekeeper. Automatically copy Rego to the ConstraintTemplate. Automatically update all ConstraintTemplates with
      library changes. Enable writing the same policies for Conftest and Gatekeeper.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ jk ];
  };
}
