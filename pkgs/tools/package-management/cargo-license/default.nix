{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-license";
  version = "0.4.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-rAHw5B/rK0N8myTzTyv/IUq3o+toWO5HOSaHQko2lPI=";
  };

  cargoSha256 = "sha256-DkINY3j0x0fUynMX8+pxNFwKI/YGqEv1M2a55FuKBGY=";

  meta = with lib; {
    description = "Cargo subcommand to see license of dependencies";
    homepage = "https://github.com/onur/cargo-license";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ basvandijk ];
  };
}
