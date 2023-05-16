<<<<<<< HEAD
{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "melody";
  version = "0.19.0";
=======
{ lib, stdenv, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "melody";
  version = "0.18.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchCrate {
    pname = "melody_cli";
    inherit version;
<<<<<<< HEAD
    sha256 = "sha256-sJVZ4dRP6mAx9g7iqwI3L2cMa5x4qQuzKWPXvOOq6q8=";
  };

  cargoHash = "sha256-8UWz+gYUxf2UNWZCnhQlGiSX6kPsHPlYcdl7wD3Rchs=";
=======
    sha256 = "sha256-Az1pGRty7wAC5fN7RlO/etaW5w5TrsO6VVXv5M7NUfU=";
  };

  cargoSha256 = "sha256-EhPrARdDnwdxfK1JHuuHVrxSDZhuE+kTBQr45JxluUA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Language that compiles to regular expressions";
    homepage = "https://github.com/yoav-lavi/melody";
    license = licenses.mit;
    maintainers = with maintainers; [ joelkoen ];
  };
}
