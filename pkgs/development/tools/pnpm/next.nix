{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  testers,

  version,
  hash,
  cargoHash,
  knownVulnerabilities ? [ ],
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pnpm";
  inherit version;

  src = fetchFromGitHub {
    owner = "pnpm";
    repo = "pnpm";
    tag = "v${finalAttrs.version}";
    inherit hash;
  };

  inherit cargoHash;

  cargoBuildFlags = [
    "--bin"
    "pnpm"
  ];

  # Integration tests require running network and external fixtures
  doCheck = false;

  __structuredAttrs = true;

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  # TODO: find a proper way to provide pnpx/pnx (which run `pnpm dlx "$@"`).
  postInstall = ''
    install -d $out/bin
    ln -s pnpm $out/bin/pn
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $out/bin/pnpm completion bash > pnpm.bash
    $out/bin/pnpm completion fish > pnpm.fish
    $out/bin/pnpm completion zsh > pnpm.zsh
    installShellCompletion pnpm.{bash,fish,zsh}
  '';

  passthru = {
    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
      };
    };
  };

  meta = {
    description = "Fast, disk space efficient package manager for JavaScript";
    homepage = "https://pnpm.io/";
    changelog = "https://github.com/pnpm/pnpm/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Scrumplex
      gepbird
    ];
    platforms = lib.platforms.all;
    mainProgram = "pnpm";
    inherit knownVulnerabilities;
  };
})
