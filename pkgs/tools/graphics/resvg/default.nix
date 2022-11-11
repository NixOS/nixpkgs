{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "resvg";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XD0FEvmTDrjRD72FY6fWdAKhYSBCYVThaI9O1ToSbrc=";
  };

  cargoSha256 = "sha256-gprXkLz4lvxopKHqmMNkkS4z6NTOKMAHNR1zemRNUMg=";

  meta = with lib; {
    description = "An SVG rendering library";
    homepage = "https://github.com/RazrFalcon/resvg";
    changelog = "https://github.com/RazrFalcon/resvg/raw/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
  };
}
