{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "svg2pdf";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "typst";
    repo = "svg2pdf";
    rev = "v${version}";
    hash = "sha256-mWj9zWxqcJ+5VFYSaeNLxClWdOGd34JboZBwT8E75Ew=";
  };

  cargoHash = "sha256-zP448dFnkoPca/GJA2kT5ht1fVGkWN0XdaKEePJaloQ=";

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
