{ lib
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, stdenv
, curl
, CoreFoundation
, Security
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-outdated";
<<<<<<< HEAD
  version = "0.13.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-u8VMVW2LJcwDRv43705aOcP0WMRfB3hakdgufYuI7I4=";
  };

  cargoHash = "sha256-rXLgNzbzMZG+nviAnK9n7ISWuNOPMugubHNMwJRKRZc=";
=======
  version = "0.11.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-SkFMdE7VAZrT7e5SMrfW8bBA6zPqQV7LhSy3OmshUAs=";
  };

  cargoHash = "sha256-ZcG/4vyrcJNAMiZdR3MFyqX5Udn8wGAfiGT5uP1BSMo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [
    curl
    CoreFoundation
    Security
    SystemConfiguration
  ];

  meta = with lib; {
    description = "A cargo subcommand for displaying when Rust dependencies are out of date";
    homepage = "https://github.com/kbknapp/cargo-outdated";
<<<<<<< HEAD
    changelog = "https://github.com/kbknapp/cargo-outdated/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ ivan matthiasbeyer ];
=======
    changelog = "https://github.com/kbknapp/cargo-outdated/blob/${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ ivan ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
