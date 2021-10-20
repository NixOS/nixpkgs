{ lib, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, installShellFiles
, openssl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "tealdeer";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "dbrgn";
    repo = "tealdeer";
    rev = "v${version}";
    sha256 = "1f37qlw4nxdhlqlqzzb4j11gsv26abk2nk2qhbzj77kp4v2b125x";
  };

  cargoSha256 = "1rjnparpcn8rnqy43xl4gg151p1a0zj9sna600hz01r41g1hgccq";

  buildInputs = if stdenv.isDarwin then [ Security ] else [ openssl ];

  nativeBuildInputs = [ installShellFiles pkg-config ];

  postInstall = ''
    installShellCompletion --bash --name tealdeer.bash bash_tealdeer
    installShellCompletion --fish --name tealdeer.fish fish_tealdeer
    installShellCompletion --zsh --name _tealdeer zsh_tealdeer
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
