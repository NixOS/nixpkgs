{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "svg2pdf";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "typst";
    repo = "svg2pdf";
    rev = "v${version}";
    hash = "sha256-XTOGxuytbkaq4ZV6rXKJF9A/KSX6naYQ3kdICDQU4JA=";
  };
  cargoHash = "sha256-CQPkVJ3quQlnIS05tAj+i7kGk2l0RvGM/FRNvgQ0mHM=";
  buildFeatures = [ "cli" ];

  meta = with lib; {
    description = "Convert SVG files to PDFs";
    homepage = "https://github.com/typst/svg2pdf";
    changelog = "https://github.com/typst/svg2pdf/releases/tag/${src.rev}";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ doronbehar figsoda ];
  };
}
