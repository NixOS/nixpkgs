{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, installShellFiles
, openssl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "tealdeer";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "dbrgn";
    repo = "tealdeer";
    rev = "v${version}";
    sha256 = "sha256-c7HYQtNT3e/GRyhS6sVGBw91cIusWmOqQ3i+Gglc/Ks=";
  };

  cargoSha256 = "sha256-CLCY4rKdYX3QZvk18Ty9B3kcC6hXsDTpAFG0S5xusEQ=";

  buildInputs = if stdenv.isDarwin then [ Security ] else [ openssl ];

  nativeBuildInputs = [ installShellFiles pkg-config ];

  postInstall = ''
    installShellCompletion --cmd tldr \
      --bash completion/bash_tealdeer \
      --fish completion/fish_tealdeer \
      --zsh completion/zsh_tealdeer
  '';

  # disable tests for now since one needs network
  # what is unavailable in sandbox build
  # and i can't disable just this one
  doCheck = false;

  meta = with lib; {
    description = "A very fast implementation of tldr in Rust";
    homepage = "https://github.com/dbrgn/tealdeer";
    maintainers = with maintainers; [ davidak ];
    license = with licenses; [ asl20 mit ];
    mainProgram = "tldr";
  };
}
