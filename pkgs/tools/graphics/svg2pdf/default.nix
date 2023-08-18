{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "svg2pdf";
  version = "0.6.0";
  # This cargo package is usually a library, hence it does not track a
  # Cargo.lock by default so we use fetchCrate
  src = fetchCrate {
    inherit version pname;
    sha256 = "sha256-RZpJ2HNqO1y6ZQjxdd7LEH2yS5QyjSqQFuyU4BwFA+4=";
  };
  cargoHash = "sha256-wJr1K/PUewScGjVLBmg9lpDKyn5CIUK2zac9/+JvnbE=";
  buildFeatures = [ "cli" ];

  doCheck = true;

  meta = with lib; {
    description = "Convert SVG files to PDFs";
    homepage = "https://github.com/typst/svg2pdf";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ doronbehar ];
  };
}
