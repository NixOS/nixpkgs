{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, IOKit
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "oxigraph";
  version = "0.3.17";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-UsoNsGS2JWiI1EotUXjKwtR0WIk+z/5/a0AJySw4xnQ=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-lQVWpIhWTUQTcMaPJ1z8wJI7/EBU+YoFkC92JhLCxe8=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];
  buildInputs = lib.optionals stdenv.isDarwin [ IOKit Security ];

  cargoBuildFlags = [ "--package" "oxigraph_server" ];

  # requires packaging of the associated python modules
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/oxigraph/oxigraph";
    description = "SPARQL graph database";
    platforms = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
    maintainers = with maintainers; [ astro ];
    license = with licenses; [ asl20 mit ];
  };
}
