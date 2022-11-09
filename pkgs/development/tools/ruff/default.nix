{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, CoreServices
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "ruff";
  version = "0.0.108";

  src = fetchFromGitHub {
    owner = "charliermarsh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-I2F4x4gsmL22j+atfxRQLKmKLdIwbXEEN8EcXV4ZAJA=";
  };

  cargoSha256 = "sha256-EJm1bfJ9/Jqe0tCQftAz3qR8TBGxcZiqJnJ2QnhyE58=";

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
