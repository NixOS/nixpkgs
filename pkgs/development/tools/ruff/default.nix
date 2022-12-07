{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, CoreServices
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "ruff";
  version = "0.0.168";

  src = fetchFromGitHub {
    owner = "charliermarsh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fQBtFhKngoIl4I2Wa7quFZrmNBhQhSCVp5gw3LTYIio=";
  };

  cargoSha256 = "sha256-kLdO+b04YfdMex1B5Mx+EzDD3kkx5EktCPwTVbxKZ+c=";

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreServices
    Security
  ];

  meta = with lib; {
    description = "An extremely fast Python linter";
    homepage = "https://github.com/charliermarsh/ruff";
    changelog = "https://github.com/charliermarsh/ruff/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
