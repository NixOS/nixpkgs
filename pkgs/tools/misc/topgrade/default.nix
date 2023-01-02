{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, AppKit
, Cocoa
, Foundation
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "topgrade";
  version = "10.2.4";

  src = fetchFromGitHub {
    owner = "topgrade-rs";
    repo = "topgrade";
    rev = "v${version}";
    hash = "sha256-b1nWTQ+m4b6XzDTR36ubf5nTdUuWK94F2P4Q3tUvHAw=";
  };

  cargoHash = "sha256-7GSkFh0Fefl9VlCdPdVZ9IsyN0IKUob5c43v84PtrcI=";

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    AppKit
    Cocoa
    Foundation
  ];

  NIX_CFLAGS_COMPILE = lib.optionals stdenv.isDarwin [
    "-framework"
    "AppKit"
  ];

  postInstall = ''
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
    maintainers = with maintainers; [ SuperSandro2000 xyenon ];
  };
}
