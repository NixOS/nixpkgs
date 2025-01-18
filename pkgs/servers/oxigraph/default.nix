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
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-EG9VLDS9BhgPwr2Z7SGWe9l9j5Yg9KdRysvd9KGQDgk=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-GFtKToMnQc3NUKjOn8jj2pj3tdqY6G2abgLSh6nGbic=";

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
