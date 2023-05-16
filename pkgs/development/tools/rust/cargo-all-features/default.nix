{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-all-features";
<<<<<<< HEAD
  version = "1.10.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-/w3Xd7PXUNtqzRYmUqJtth+GDuXSnsk1NiYCTYsHuAQ=";
  };

  cargoHash = "sha256-d69jj2FGptjndJG1tq3Fb/8F3kuFXN5otsYGhXYhhZg=";
=======
  version = "1.9.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-OLnz1SmMLs/yats/lZugqNUlBQHSNR1bOuEmnHGdoN8=";
  };

  cargoHash = "sha256-Gg5tF8IvbtIoqR0AKRS7IbcCNOCJO8oxwX0KkUr+l/M=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A Cargo subcommand to build and test all feature flag combinations";
    homepage = "https://github.com/frewsxcv/cargo-all-features";
    license = with licenses; [ asl20 /* or */ mit ];
<<<<<<< HEAD
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
=======
    maintainers = with maintainers; [ figsoda ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
