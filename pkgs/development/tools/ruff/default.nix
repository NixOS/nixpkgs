{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, CoreServices
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "ruff";
  version = "0.0.61";

  src = fetchFromGitHub {
    owner = "charliermarsh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Gmuf8vZMP74r3CtImmD9hCTPIxaMfHGXO0C/hGAyqb0=";
  };

  cargoSha256 = "sha256-jSBTou8GekqHoTTXRrhCwCWA2tjU5woKKB0g63M2VGU=";

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
