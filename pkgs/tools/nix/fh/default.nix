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
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "DeterminateSystems";
    repo = "fh";
    rev = "v${version}";
    hash = "sha256-gyxlVSraZIVAyOaJk90fub4b8g1w4KXwqa1ecNAC7xA=";
  };

  cargoHash = "sha256-Tm/O9H0l37h+2zb4dgO6Z6CaYye8O+zVMrsUpWJ9okI=";

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

  meta = with lib; {
    description = "The official FlakeHub CLI";
    homepage = "https://github.com/DeterminateSystems/fh";
    changelog = "https://github.com/DeterminateSystems/fh/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "fh";
  };
}
