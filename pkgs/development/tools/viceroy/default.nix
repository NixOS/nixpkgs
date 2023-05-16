{ rustPlatform, fetchFromGitHub, lib, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "viceroy";
<<<<<<< HEAD
  version = "0.7.0";
=======
  version = "0.4.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "fastly";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-ml9N4oxq80A1y7oFE98eifFIEtdcT9IRhXwDMEJ298k=";
=======
    hash = "sha256-EfkN0cKCoe6NA3thCVb2uY664GmQdSitv1yg/DTYtls=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = lib.optional stdenv.isDarwin Security;

<<<<<<< HEAD
  cargoHash = "sha256-PC2StxMefsiKaY9fXIG4167G9SoWlbmJBDGwrFBa4os=";
=======
  cargoHash = "sha256-BT1wslIrCCmehWfs9QuT5/HqKJVq5BkoyfKvUIx2nQw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  cargoTestFlags = [
    "--package viceroy-lib"
  ];

  meta = with lib; {
    description = "Viceroy provides local testing for developers working with Compute@Edge";
    homepage = "https://github.com/fastly/Viceroy";
    license = licenses.asl20;
    maintainers = with maintainers; [ ereslibre shyim ];
    platforms = platforms.unix;
  };
}
