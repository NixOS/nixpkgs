{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
, darwin
, gcc
, libcxx
}:

rustPlatform.buildRustPackage rec {
  pname = "fh";
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "DeterminateSystems";
    repo = "fh";
    rev = "v${version}";
    hash = "sha256-fRaKydMSwd1zl6ptBKvn5ej2pqtI8xi9dioFmR8QA+g=";
  };

  # fix bindgen generation with clang_18
  # can be removed when upstream uses bindgen 0.69.2 or later
  cargoPatches = [ ./fix-clang-18-bindgen-version-cargo-lock.patch ];

  cargoHash = "sha256-M5NUQytM8ZBLksUmTL2D5bOUqdrZEOvvF4okjvUXYnc=";

  nativeBuildInputs = [
    installShellFiles
    rustPlatform.bindgenHook
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    gcc.cc.lib
  ];

  env = lib.optionalAttrs stdenv.isDarwin {
    NIX_CFLAGS_COMPILE = "-I${lib.getDev libcxx}/include/c++/v1";
  };

  postInstall = ''
    installShellCompletion --cmd fh \
      --bash <($out/bin/fh completion bash) \
      --fish <($out/bin/fh completion fish) \
      --zsh <($out/bin/fh completion zsh)
  '';

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Official FlakeHub CLI";
    homepage = "https://github.com/DeterminateSystems/fh";
    changelog = "https://github.com/DeterminateSystems/fh/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "fh";
  };
}
