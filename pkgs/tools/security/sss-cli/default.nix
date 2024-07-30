{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "sss-cli";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "dsprenkels";
    repo = "sss-cli";
    rev = "v${version}";
    hash = "sha256-9Wht+t48SsWpj1z2yY6P7G+h9StmuqfMdODtyPffhak=";
  };

  cargoPatches = [ ./fix-cargo-lock.patch ];

  cargoHash = "sha256-nKb0J9ym3ZYC80KemwQwT5vVtQUngYD4/091hAIYAiU=";

  meta = with lib; {
    homepage = "https://github.com/dsprenkels/sss-cli";
    description = "Command line program for secret-sharing strings";
    license = licenses.mit;
    maintainers = with maintainers; [ laalsaas ];
  };
}
