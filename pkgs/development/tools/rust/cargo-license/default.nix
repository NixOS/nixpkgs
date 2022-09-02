{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-license";
  version = "0.5.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-z68idQqjH0noNZLwoTtnLrIOXZPG4kAYS9+7yrFXKOA=";
  };

  cargoSha256 = "sha256-8QgDKgJC5l2h5ysQaICjToI7gGxnmlolTwEtxHJMlj8=";

  meta = with lib; {
    description = "Cargo subcommand to see license of dependencies";
    homepage = "https://github.com/onur/cargo-license";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ basvandijk ];
  };
}
