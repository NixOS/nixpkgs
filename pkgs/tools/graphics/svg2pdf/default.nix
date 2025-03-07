{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "svg2pdf";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "typst";
    repo = "svg2pdf";
    rev = "v${version}";
    hash = "sha256-gSXztee8tly8nNhcC4QcloOAgVpenWszg12w3thzKJ8=";
  };

  cargoHash = "sha256-PaAhTSfw+enirVg9WHBpI+GjMwHA02/SiKkRa1A6QXc=";

  cargoBuildFlags = [
    "-p=svg2pdf-cli"
  ];

  meta = with lib; {
    description = "Convert SVG files to PDFs";
    homepage = "https://github.com/typst/svg2pdf";
    changelog = "https://github.com/typst/svg2pdf/releases/tag/${src.rev}";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ doronbehar figsoda ];
    mainProgram = "svg2pdf";
  };
}
