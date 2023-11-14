{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-mommy";
  version = "0.2.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-/f6jHXwUJqAlqmVvvxfB4tvKkYwCmqI8GgPBHf5Qg1E=";
  };

  cargoSha256 = "sha256-hj6oRuTlCxGq5SosVBkVwrG0Sgv5iDz5naCXPueYFqM=";

  meta = with lib; {
    description = "Cargo wrapper that encourages you after running commands";
    homepage = "https://github.com/Gankra/cargo-mommy";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ GoldsteinE ];
  };
}
