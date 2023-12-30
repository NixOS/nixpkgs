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
  version = "0.87.7";

  src = fetchFromGitHub {
    owner = "tursodatabase";
    repo = "turso-cli";
    rev = "v${version}";
    hash = "sha256-ydjYkJsHSu+jgxbup5L1GFN+c4q3gpuplUBT2Av7RgI=";
  };

  vendorHash = "sha256-rTeW2RQhcdwJTAMQELm4cdObJbm8gk/I2Qz3Wk3+zpI=";

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
