{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:
buildGoModule rec {
  pname = "turso-cli";
  version = "0.95.0";

  src = fetchFromGitHub {
    owner = "tursodatabase";
    repo = "turso-cli";
    rev = "v${version}";
    hash = "sha256-9QrDtqF9A3UhStKtwkq/FCULoJQz+RjS7yEolZbBLCw=";
  };

  vendorHash = "sha256-2NjdjB09WYzHjQEl2hMUWN1/xsj/Hlr8lVYU/pkxTqQ=";

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
    description = "This is the command line interface (CLI) to Turso";
    homepage = "https://turso.tech";
    mainProgram = "turso";
    license = licenses.mit;
    maintainers = with maintainers; [ zestsystem kashw2 fryuni ];
  };
}
