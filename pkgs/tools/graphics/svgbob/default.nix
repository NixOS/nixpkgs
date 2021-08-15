{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "svgbob";
  version = "0.5.4";

  src = fetchCrate {
    inherit version;
    crateName = "svgbob_cli";
    sha256 = "0qq7hkg32bqyw3vz3ibip7yrjg5m2ch9kdnwqrzaqqy9wb8d7154";
  };

  cargoSha256 = "0p37qkgh1xpqmkr2p88njwhifpyqfh27qcwmmhwxdqcpzmmmkjhr";

  meta = with lib; {
    description = "Convert your ascii diagram scribbles into happy little SVG";
    homepage = "https://github.com/ivanceras/svgbob";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
