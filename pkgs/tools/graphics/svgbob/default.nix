{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "svgbob";
  version = "0.6.2";

  src = fetchCrate {
    inherit version;
    crateName = "svgbob_cli";
    sha256 = "sha256-9JASoUN/VzZS8ihepTQL2SXZitxKBMSJEv+13vzQd3w=";
  };

  cargoSha256 = "sha256-pkdiow+9gsQ9rrSHwukd17r5CfsaJgYj6KA4wYKbtA0=";

  meta = with lib; {
    description = "Convert your ascii diagram scribbles into happy little SVG";
    homepage = "https://github.com/ivanceras/svgbob";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
