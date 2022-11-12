{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, CoreServices
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "ruff";
  version = "0.0.113";

  src = fetchFromGitHub {
    owner = "charliermarsh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ZP3kIr8W/b2+BXzl7CBzqZz2vBsR/i0LUT6Pc2QT21Y=";
  };

  cargoSha256 = "sha256-vPvSdET+T8DsYdBz9Y1TLDShJ+iC3cLu1TmUsslcpi4=";

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
