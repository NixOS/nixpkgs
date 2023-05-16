{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "swc";
<<<<<<< HEAD
  version = "0.91.69";

  env = {
    # swc depends on nightly features
    RUSTC_BOOTSTRAP = 1;
  };
=======
  version = "0.91.19";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchCrate {
    pname = "swc_cli";
    inherit version;
<<<<<<< HEAD
    sha256 = "sha256-8zbxE1qkEWeSYt2L5PElZeJPRuK4Yiooy8xDmCD/PYw=";
  };

  cargoSha256 = "sha256-kRsRUOvDMRci3bN5NfhiLCWojNkSuLz3K4BfKfGYc7g=";
=======
    sha256 = "sha256-BzReetAOKSGzHhITXpm+J2Rz8d9Hq2HUagQmfst74Ag=";
  };

  cargoSha256 = "sha256-1U9YLrPYENv9iJobCxtgnQakJLDctWQwnDUtpLG3PGc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildFeatures = [ "swc_core/plugin_transform_host_native" ];

  meta = with lib; {
    description = "Rust-based platform for the Web";
    homepage = "https://github.com/swc-project/swc";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ dit7ya kashw2 ];
=======
    maintainers = with maintainers; [ dit7ya ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
