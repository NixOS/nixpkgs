{ lib
, stdenv
, fetchCrate
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "svg2pdf";
  version = "0.5.0";
  # This cargo package is usually a library, hence it does not track a
  # Cargo.lock by default so we use fetchCrate
  src = fetchCrate {
    inherit version pname;
    sha256 = "sha256-4n7aBVjXiVU7O7sOKN5eBrKZNYsKk8eDPdna9o7piJo=";
  };
  cargoHash = "sha256-5EEZoYvobbNOknwZWn71EDQSNPmYoegHoZW1Or8Xv2c=";
  buildFeatures = [ "cli" ];

  doCheck = true;

  meta = with lib; {
    description = "Convert SVG files to PDFs";
    homepage = "https://github.com/typst/svg2pdf";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ doronbehar ];
  };
}
