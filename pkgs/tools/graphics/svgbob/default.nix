{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "svgbob";
  version = "0.6.3";

  src = fetchCrate {
    inherit version;
    crateName = "svgbob_cli";
    sha256 = "sha256-yYRBV0s19J0M02wenGayy7Ebx6wDhiLiGmb+os29u9I=";
  };

  cargoSha256 = "sha256-R4W+Oe7Ks2D9qE1IpV6/AMMMwZnCfJ5DzxFAMpV2rFE=";

  meta = with lib; {
    description = "Convert your ascii diagram scribbles into happy little SVG";
    homepage = "https://github.com/ivanceras/svgbob";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
