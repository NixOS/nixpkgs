{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "svg2pdf";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "typst";
    repo = "svg2pdf";
    rev = "v${version}";
    hash = "sha256-Xy1ID2/M3v9/ZEo8fWEDlJ8+cmgAMdHhs27xDfe8IYQ=";
  };
  cargoHash = "sha256-l3671zvqSM4CY7lOXOur0Q6PBDVf6jXnhZ/8kADWQz4=";
  buildFeatures = [ "cli" ];

  meta = with lib; {
    description = "Convert SVG files to PDFs";
    homepage = "https://github.com/typst/svg2pdf";
    changelog = "https://github.com/typst/svg2pdf/releases/tag/${src.rev}";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ doronbehar figsoda ];
    mainProgram = "svg2pdf";
  };
}
