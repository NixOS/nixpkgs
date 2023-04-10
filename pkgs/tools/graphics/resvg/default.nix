{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "resvg";
  version = "0.31.0";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-CVMY/bubX+LJs3S1GmL6oPg3A/eEHwtrDpNCObE3YV0=";
  };

  cargoHash = "sha256-nM7WhzWALYwRkH4lotYT1PGZeDcBBSa8CtdyBWHSu8Y=";

  meta = with lib; {
    description = "An SVG rendering library";
    homepage = "https://github.com/RazrFalcon/resvg";
    changelog = "https://github.com/RazrFalcon/resvg/raw/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
  };
}
