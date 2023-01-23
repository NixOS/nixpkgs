{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "ruff";
  version = "0.0.231";

  src = fetchFromGitHub {
    owner = "charliermarsh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-BXRM3MS77B39B6ylrkZyLQqndF+DkjJek0u1KfOuazI=";
  };

  cargoSha256 = "sha256-HYGFE5WpY0puAmCkvByR1vomuEwA0+L9eetp6FGyPhg=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  # building tests fails with `undefined symbols`
  doCheck = false;

  meta = with lib; {
    description = "An extremely fast Python linter";
    homepage = "https://github.com/charliermarsh/ruff";
    changelog = "https://github.com/charliermarsh/ruff/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
