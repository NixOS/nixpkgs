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
    hash = "sha256-zwUiUDWdrmLF+Qj9Jy6JGXHaBskRnm+pMKW2GKGGeN8=";
    fetchSubmodules = true;
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-UnXWBq+oS7tXFCsOhlTkq0L1j8pqzXZ0QKrdYayLunA=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];
  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ IOKit Security ];

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
