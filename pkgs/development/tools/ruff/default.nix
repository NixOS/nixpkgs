{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "ruff";
  version = "0.0.196";

  src = fetchFromGitHub {
    owner = "charliermarsh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-CXiURLRxQw4x1jKqfyYPjLdajAPbbEphva+zinz+Qk8=";
  };

  cargoSha256 = "sha256-fLPodfjwqbCC/givaZJ84IR5Tl6rpxMJbMvDtJcQukE=";

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
