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
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "dbrgn";
    repo = "tealdeer";
    rev = "v${version}";
    sha256 = "sha256-yF46jCdC4UDswKa/83ZrM9VkZXQqzua2/S7y2bqYa+c=";
  };

  cargoSha256 = "sha256-BIMaVeNSdKl2A9613S+wgmb6YmiF5YJU8pTMVQfjDwI=";

  buildInputs = if stdenv.isDarwin then [ Security ] else [ openssl ];

  nativeBuildInputs = [ installShellFiles pkg-config ];

  postInstall = ''
    installShellCompletion --cmd tldr \
      --bash bash_tealdeer \
      --fish fish_tealdeer \
      --zsh zsh_tealdeer
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
