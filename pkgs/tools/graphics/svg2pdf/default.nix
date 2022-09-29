{ lib
, stdenv
, fetchCrate
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "svg2pdf";
  version = "0.4.0";
  # This cargo package is usually a library, hence it does not track a
  # Cargo.lock by default so we use fetchCrate
  src = fetchCrate {
    inherit version pname;
    sha256 = "2Aw8VYFVw0rKeaDUTsYTHcHBDP1jLm4tVGfi6+RNK9E=";
  };
  cargoSha256 = "KADfBOnkY1T1xy4Oj7s85SXcDhjRhQQ2hWGWinMXux8=";
  buildFeatures = [ "cli" ];

  doCheck = true;

  meta = with lib; {
    description = "Convert SVG files to PDFs";
    homepage = "https://github.com/typst/svg2pdf";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ doronbehar ];
  };
}
