{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, CoreServices
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "ruff";
  version = "0.0.166";

  src = fetchFromGitHub {
    owner = "charliermarsh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-APgYvtWw4v8oyir0BrqbJnBMbgBg8N9LBHDT+n/FyDY=";
  };

  cargoSha256 = "sha256-KkTOs8eGiN3rSzxdoyAr6zMMVcm6pIujrJRoTHfStuI=";

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
