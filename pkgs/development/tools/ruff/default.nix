{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, CoreServices
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "ruff";
  version = "0.0.76";

  src = fetchFromGitHub {
    owner = "charliermarsh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-PWJkn96QInAOgR0T5ISuhfI4OYQ+jMBBqFRlewoGyjI=";
  };

  cargoSha256 = "sha256-c0GxKyQtgkTY8mAgtLgH8S9TKKLyhJvxJR9uc+nVOh0=";

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
