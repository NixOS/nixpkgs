{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-lock";
  version = "9.0.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-SMxM66qo3Xmst+SVXu4LYZ0Zzn15wqVVNqqHzAkip/s=";
  };

  cargoHash = "sha256-wUp4zBY64MvD4anGlVsJrI3pyfwVSQGnn6YuweTeYNk=";

  buildFeatures = [ "cli" ];

  meta = with lib; {
    description = "Self-contained Cargo.lock parser with graph analysis";
    homepage = "https://github.com/rustsec/rustsec/tree/main/cargo-lock";
    changelog = "https://github.com/rustsec/rustsec/blob/cargo-lock/v${version}/cargo-lock/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
  };
}
