{
  lib,
  stdenv,
  buildGo121Module,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:
buildGo121Module rec {
  pname = "turso-cli";
  version = "0.86.3";

  src = fetchFromGitHub {
    owner = "tursodatabase";
    repo = "turso-cli";
    rev = "v${version}";
    hash = "sha256-hTqjNQSScQzCUBs4pYgxRnRvUSoQXXeZIceSZAR1Oa0=";
  };

  vendorHash = "sha256-EqND/W+NNatoBUMXWrsjNPfxAtX0oUASUxN6Rmhp7SQ=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-X github.com/tursodatabase/turso-cli/internal/cmd.version=v${version}"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd turso \
      --bash <($out/bin/turso completion bash) \
      --fish <($out/bin/turso completion fish) \
      --zsh <($out/bin/turso completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "This is the command line interface (CLI) to Turso.";
    homepage = "https://turso.tech";
    mainProgram = "turso";
    license = licenses.mit;
    maintainers = with maintainers; [ zestsystem kashw2 fryuni ];
  };
}
