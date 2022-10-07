{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, CoreServices
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "ruff";
  version = "0.0.60";

  src = fetchFromGitHub {
    owner = "charliermarsh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-AHKH5S+3iu+BflHnsR8kuWZKaCoyQXMa300KrvEQg5c=";
  };

  cargoSha256 = "sha256-SO6MXLqUrFWOXW63fR/RBP7XG2cy5jAKST0nLcEkIPA=";

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreServices
    Security
  ];

  meta = with lib; {
    description = "An extremely fast Python linter";
    homepage = "https://github.com/charliermarsh/ruff";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
