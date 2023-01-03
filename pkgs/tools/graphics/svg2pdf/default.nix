{ lib
, stdenv
, fetchCrate
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "svg2pdf";
  version = "0.4.1";
  # This cargo package is usually a library, hence it does not track a
  # Cargo.lock by default so we use fetchCrate
  src = fetchCrate {
    inherit version pname;
    sha256 = "sha256-0sjJIHD+x9P7FPLNwTXYcetbU4Ck5K4pFGF5cMI3+rk=";
  };
  cargoSha256 = "sha256-vjDV604HDwlaxwq5iQbGOKXmLTRgx1oZ824HXBSiouw=";
  buildFeatures = [ "cli" ];

  doCheck = true;

  meta = with lib; {
    description = "Convert SVG files to PDFs";
    homepage = "https://github.com/typst/svg2pdf";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ doronbehar ];
  };
}
