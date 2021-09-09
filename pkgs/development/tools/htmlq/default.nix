{ lib, stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "htmlq";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "mgdm";
    repo = "htmlq";
    rev = "v${version}";
    sha256 = "sha256-Q2zjrHKFWowx2yB1cdGxPnNnc8yQJz65HaX0yIqbHks=";
  };

  cargoSha256 = "sha256-pPtKPVSdEtEPmQPpNRJ4uyguDRAW0YvKgdUw5OAtbjA=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  doCheck = false;

  meta = with lib; {
    description = "Like jq, but for HTML";
    homepage = "https://github.com/mgdm/htmlq";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben nerdypepper ];
  };
}
