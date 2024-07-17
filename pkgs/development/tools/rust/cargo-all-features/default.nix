{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-all-features";
  version = "1.10.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-/w3Xd7PXUNtqzRYmUqJtth+GDuXSnsk1NiYCTYsHuAQ=";
  };

  cargoHash = "sha256-d69jj2FGptjndJG1tq3Fb/8F3kuFXN5otsYGhXYhhZg=";

  meta = with lib; {
    description = "A Cargo subcommand to build and test all feature flag combinations";
    homepage = "https://github.com/frewsxcv/cargo-all-features";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [
      figsoda
      matthiasbeyer
    ];
  };
}
