{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-toml-lint";
  version = "0.1.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-U3y9gnFvkqJmyFqRAUQorJQY0iRzAE9UUXzFmgZIyaM=";
  };

  cargoHash = "sha256-ujdekIucqes2Wya4jwTMLstb8JMptbAlqYhgMxfp2gg=";

  meta = with lib; {
    description = "A simple linter for Cargo.toml manifests";
    homepage = "https://github.com/fuellabs/cargo-toml-lint";
    changelog = "https://github.com/fuellabs/cargo-toml-lint/releases/tag/v${version}";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ mitchmindtree matthiasbeyer ];
  };
}
