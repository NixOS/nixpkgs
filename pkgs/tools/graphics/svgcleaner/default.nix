{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "SVGCleaner";
  version = "unstable-2021-08-30";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = pname;
    rev = "575eac74400a5ac45c912b144f0c002aa4a0135f";
    sha256 = "sha256-pRDRRVb8Lyna8X/PEjS9tS5dbG4g7vyMCU5AqPlpxec=";
  };

  cargoSha256 = "sha256-SZWmJGiCc/FevxMWJpa8xKVz/rbll52oNbFtqPpz74g=";

  meta = with lib; {
    description = "Clean and optimize SVG files from unnecessary data";
    homepage = "https://github.com/RazrFalcon/SVGCleaner";
    changelog = "https://github.com/RazrFalcon/svgcleaner/releases";
    license = licenses.gpl2;
    maintainers = with maintainers; [ yuu ];
    mainProgram = "svgcleaner";
  };
}
