{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "ruff";
  version = "0.0.201";

  src = fetchFromGitHub {
    owner = "charliermarsh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+Jt7uvwzA1AtSaQOqsZBm9k0OBSvOaAoNBpsiZ/G+wI=";
  };

  cargoSha256 = "sha256-8wxS1ViA5F+y8gkKfSENYga/YSZ7QE8cl2lQlVL382Y=";

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
