{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "svg2pdf";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "typst";
    repo = "svg2pdf";
    rev = "v${version}";
    hash = "sha256-4gCEm/E7lzd6pLyJnEEswtpZ45cCxAaHMxOWMY0I2Y8=";
  };

  cargoHash = "sha256-PBnOGXV9Q9BMxhzx/xs2hXsy0wzcCvrspee6M4WxqX0=";

  cargoBuildFlags = [
    "-p=svg2pdf-cli"
  ];

  meta = with lib; {
    description = "Convert SVG files to PDFs";
    homepage = "https://github.com/typst/svg2pdf";
    changelog = "https://github.com/typst/svg2pdf/releases/tag/${src.rev}";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [
      doronbehar
      figsoda
    ];
    mainProgram = "svg2pdf";
  };
}
