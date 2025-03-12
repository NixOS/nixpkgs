{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, installShellFiles
, IOKit
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "oxigraph";
  version = "0.4.8";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-yMXNt7pGiwYDXjmHxKUQpqNrAmnFpg21Vc5R1DmwsHc=";
    fetchSubmodules = true;
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-qOGpM3SOAOMO5W3wj4ruXlymp9bV4sqOU75gMVSEyfk=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    installShellFiles
  ];
  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ IOKit Security ];

  buildAndTestSubdir = "cli";
  buildNoDefaultFeatures = true;
  buildFeatures = [ "rustls-webpki" "geosparql" ];

  # Man pages and autocompletion
  postInstall = ''
    MAN_DIR="$(find target/*/release -name man)"
    installManPage "$MAN_DIR"/*.1
    COMPLETE_DIR="$(find target/*/release -name complete)"
    installShellCompletion --bash --name oxigraph.bash "$COMPLETE_DIR/oxigraph.bash"
    installShellCompletion --fish --name oxigraph.fish "$COMPLETE_DIR/oxigraph.fish"
    installShellCompletion --zsh --name _oxigraph "$COMPLETE_DIR/_oxigraph"
  '';

  cargoCheckNoDefaultFeatures = true;
  cargoCheckFeatures = buildFeatures;

  meta = with lib; {
    homepage = "https://github.com/oxigraph/oxigraph";
    description = "SPARQL graph database";
    platforms = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
    maintainers = with maintainers; [ astro ];
    license = with licenses; [ asl20 mit ];
    mainProgram = "oxigraph";
  };
}
