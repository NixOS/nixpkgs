{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-admonish";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "tommilligan";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-B0WfOvt037U56G9C7vfAVP4CElodszEUj8h/UD+qv4I=";
  };

  cargoHash = "sha256-EmNy7YjltUgPgAp/L/VjCVG2pu//o7Bq7v+B3vO5ipM=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "A preprocessor for mdbook to add Material Design admonishments";
    license = licenses.mit;
    maintainers = with maintainers; [ jmgilman Frostman ];
    homepage = "https://github.com/tommilligan/mdbook-admonish";
  };
}
