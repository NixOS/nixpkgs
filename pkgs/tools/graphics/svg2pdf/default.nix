{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "svg2pdf";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "typst";
    repo = "svg2pdf";
    rev = "v${version}";
    hash = "sha256-X5L3UA/BJw8M2G35biCQjExYe68fB14meW4ILPEyesc=";
  };
  cargoHash = "sha256-zR4nKzbbCzSM1JVxj3nk6yQAfpPmfVQGabkU7lzLAi0=";
  buildFeatures = [ "cli" ];

  meta = with lib; {
    description = "Convert SVG files to PDFs";
    homepage = "https://github.com/typst/svg2pdf";
    changelog = "https://github.com/typst/svg2pdf/releases/tag/${src.rev}";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ doronbehar figsoda ];
  };
}
