{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "svgbob";
  version = "0.5.3";

  src = fetchCrate {
    inherit version;
    crateName = "svgbob_cli";
    sha256 = "1gi8h4wzpi477y1gwi4708pn2kr65934a4dmphbhwppxbw447qiw";
  };

  cargoSha256 = "1x8phpllwm12igaachghwq6wgxl7nl8bhh7xybfrmn447viwxhq2";

  meta = with lib; {
    description = "Convert your ascii diagram scribbles into happy little SVG";
    homepage = "https://github.com/ivanceras/svgbob";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
