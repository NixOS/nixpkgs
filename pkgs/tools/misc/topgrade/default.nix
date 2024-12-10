{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  AppKit,
  Cocoa,
  Foundation,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "topgrade";
  version = "16.0.2";

  src = fetchFromGitHub {
    owner = "topgrade-rs";
    repo = "topgrade";
    rev = "v${version}";
    hash = "sha256-0wJxBFGPjJReWoeeKpHEsKaB3npR8nf7Uw8BgPQ+ccs=";
  };

  cargoHash = "sha256-ac62RyjQujEYAOcoGOMlDlbx1MmVmrRKoNpgb3dFUFk=";

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    AppKit
    Cocoa
    Foundation
  ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.hostPlatform.isDarwin [
      "-framework"
      "AppKit"
    ]
  );

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd topgrade \
      --bash <($out/bin/topgrade --gen-completion bash) \
      --fish <($out/bin/topgrade --gen-completion fish) \
      --zsh <($out/bin/topgrade --gen-completion zsh)

    $out/bin/topgrade --gen-manpage > topgrade.8
    installManPage topgrade.8
  '';

  meta = with lib; {
    description = "Upgrade all the things";
    homepage = "https://github.com/topgrade-rs/topgrade";
    changelog = "https://github.com/topgrade-rs/topgrade/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      SuperSandro2000
      xyenon
    ];
    mainProgram = "topgrade";
  };
}
