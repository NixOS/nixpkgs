{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "fclones";
<<<<<<< HEAD
  version = "0.32.1";
=======
  version = "0.30.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "pkolaczk";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-aNTmx94fWuwwlMckjZMOoU1hqSW+yUTKjobvRTxJX4s=";
  };

  cargoHash = "sha256-MGqQImBEH210IVvjyh/aceQr001T1cMHQfyQI1ZyVw8=";
=======
    sha256 = "sha256-eFWFXUARXy3VA53VPSZkJdw6ZvI+FtFnCCGHmCAdTto=";
  };

  cargoHash = "sha256-C7DKwEMYdypfItflMOL7rjbAdXDRsXDNoPlc9j6aBRA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk_11_0.frameworks.AppKit
  ];

  # device::test_physical_device_name test fails on Darwin
  doCheck = !stdenv.isDarwin;

  checkFlags = [
    # ofborg sometimes fails with "Resource temporarily unavailable"
    "--skip=cache::test::return_none_if_different_transform_was_used"
  ];

  meta = with lib; {
    description = "Efficient Duplicate File Finder and Remover";
    homepage = "https://github.com/pkolaczk/fclones";
<<<<<<< HEAD
    changelog = "https://github.com/pkolaczk/fclones/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ cyounkins figsoda msfjarvis ];
=======
    license = licenses.mit;
    maintainers = with maintainers; [ cyounkins msfjarvis ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
