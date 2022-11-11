{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-lock";
  version = "8.0.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-I64LXY8e8ztICS6AKfrNr/7Ntap7ESjindNWEeny6ZA=";
  };

  cargoSha256 = "sha256-Yy7KQvPeyw5YSzUmoxUJAueVzkfQqDPE1j2+L+KifpU=";

  buildFeatures = [ "cli" ];

  meta = with lib; {
    description = "Self-contained Cargo.lock parser with graph analysis";
    homepage = "https://github.com/rustsec/rustsec/tree/main/cargo-lock";
    changelog = "https://github.com/rustsec/rustsec/blob/cargo-lock/v${version}/cargo-lock/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
