{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "svg2pdf";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "typst";
    repo = "svg2pdf";
    rev = "v${version}";
    hash = "sha256-iN6/VO6EMP9wMoTn4t0y1Oq9XP9Q3UcRNCWsMzI4Fn8=";
  };
  cargoHash = "sha256-Xxb8DeTAmw0Pq4mrLVcpEuzq7/SX+AlUSWoA2dcVQJA=";
  buildFeatures = [ "cli" ];

  meta = with lib; {
    description = "Convert SVG files to PDFs";
    homepage = "https://github.com/typst/svg2pdf";
    changelog = "https://github.com/typst/svg2pdf/releases/tag/${src.rev}";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ doronbehar figsoda ];
  };
}
