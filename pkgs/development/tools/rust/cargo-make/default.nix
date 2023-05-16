{ lib
<<<<<<< HEAD
, rustPlatform
, fetchFromGitHub
, pkg-config
, bzip2
, openssl
, stdenv
, darwin
=======
, stdenv
, fetchurl
, runCommand
, fetchCrate
, rustPlatform
, Security
, openssl
, pkg-config
, SystemConfiguration
, libiconv
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-make";
<<<<<<< HEAD
  version = "0.37.0";

  src = fetchFromGitHub {
    owner = "sagiegurari";
    repo = "cargo-make";
    rev = version;
    hash = "sha256-gc/0mlhQdE9tnCpDQ2vSWX4WcqnPxRjmL6YPtYGEn5E=";
  };

  cargoHash = "sha256-ut9s+kMATtmOfyIp+TwmdQtlObiZexWbh1p1tcCpYGo=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    bzip2
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];
=======
  version = "0.36.7";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-OE24RKbSWylX2dXkjBMZ8Va9ONVeMKG/BVdlZD6O+Yc=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security SystemConfiguration libiconv ];

  cargoHash = "sha256-AAZYY9CbLbbvWWMhkHOc8OhzmwSFXSL9jSga3qMbkDU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Some tests fail because they need network access.
  # However, Travis ensures a proper build.
  # See also:
  #   https://travis-ci.org/sagiegurari/cargo-make
  doCheck = false;

  meta = with lib; {
    description = "A Rust task runner and build tool";
    homepage = "https://github.com/sagiegurari/cargo-make";
<<<<<<< HEAD
    changelog = "https://github.com/sagiegurari/cargo-make/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda xrelkd ];
    mainProgram = "cargo-make";
=======
    license = licenses.asl20;
    maintainers = with maintainers; [ xrelkd ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
