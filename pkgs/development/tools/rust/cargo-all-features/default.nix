{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-all-features";
  version = "1.9.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-OLnz1SmMLs/yats/lZugqNUlBQHSNR1bOuEmnHGdoN8=";
  };

  cargoHash = "sha256-Gg5tF8IvbtIoqR0AKRS7IbcCNOCJO8oxwX0KkUr+l/M=";

  meta = with lib; {
    description = "A Cargo subcommand to build and test all feature flag combinations";
    homepage = "https://github.com/frewsxcv/cargo-all-features";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
