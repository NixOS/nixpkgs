{ lib
<<<<<<< HEAD
, rustPlatform
, fetchCrate
=======
, stdenv
, fetchCrate
, rustPlatform
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

rustPlatform.buildRustPackage rec {
  pname = "svg2pdf";
<<<<<<< HEAD
  version = "0.6.0";
=======
  version = "0.4.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # This cargo package is usually a library, hence it does not track a
  # Cargo.lock by default so we use fetchCrate
  src = fetchCrate {
    inherit version pname;
<<<<<<< HEAD
    sha256 = "sha256-RZpJ2HNqO1y6ZQjxdd7LEH2yS5QyjSqQFuyU4BwFA+4=";
  };
  cargoHash = "sha256-wJr1K/PUewScGjVLBmg9lpDKyn5CIUK2zac9/+JvnbE=";
=======
    sha256 = "sha256-0sjJIHD+x9P7FPLNwTXYcetbU4Ck5K4pFGF5cMI3+rk=";
  };
  cargoSha256 = "sha256-vjDV604HDwlaxwq5iQbGOKXmLTRgx1oZ824HXBSiouw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildFeatures = [ "cli" ];

  doCheck = true;

  meta = with lib; {
    description = "Convert SVG files to PDFs";
    homepage = "https://github.com/typst/svg2pdf";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ doronbehar ];
  };
}
