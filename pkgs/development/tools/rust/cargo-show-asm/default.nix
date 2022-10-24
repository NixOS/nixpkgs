{ lib
, rustPlatform
, fetchFromGitHub
, curl
, installShellFiles
, pkg-config
, openssl
, stdenv
, darwin
, nix-update-script
, callPackage
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-asm";
  version = "0.1.24";

  src = fetchFromGitHub {
    owner = "pacak";
    repo = "cargo-show-asm";
    rev = version;
    hash = "sha256-ahkKUtg5M88qddzEwYxPecDtBofGfPVxKuYKgmsbWYc=";
  };

  cargoHash = "sha256-S7OpHNjiTfQg7aPmHEx6Q/OV5QA9pB29F3MTIeiLAXg=";

  nativeBuildInputs = [
    curl.dev
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    curl
    openssl
  ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    CoreFoundation
    SystemConfiguration
  ]);

  postInstall = ''
    installShellCompletion --cmd cargo-asm \
      --bash <($out/bin/cargo-asm --bpaf-complete-style-bash) \
      --fish <($out/bin/cargo-asm --bpaf-complete-style-fish) \
      --zsh  <($out/bin/cargo-asm --bpaf-complete-style-zsh)
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
    tests = lib.optionalAttrs stdenv.hostPlatform.isx86_64 {
      test-basic-x86_64 = callPackage ./test-basic-x86_64.nix { };
    };
  };

  meta = with lib; {
    description = "Cargo subcommand showing the assembly, LLVM-IR and MIR generated for Rust code";
    homepage = "https://github.com/pacak/cargo-show-asm";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda oxalica ];
  };
}
