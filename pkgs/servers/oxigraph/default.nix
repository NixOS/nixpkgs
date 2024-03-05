{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, IOKit
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "oxigraph";
  version = "0.3.22";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zwUiUDWdrmLF+Qj9Jy6JGXHaBskRnm+pMKW2GKGGeN8=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-O9/YvvFOaZ1F7HYO/AplWLz1vw0hysJEvGketk8zb9w=";

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
    mainProgram = "oxigraph_server";
  };
}
