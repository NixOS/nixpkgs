{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2_1_5
, openssl
, zlib
, zstd
, stdenv
, curl
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deny";
  version = "0.13.9";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = pname;
    rev = version;
    hash = "sha256-fkbYPn7GmnOgLvJqbizVKKLBnzVn0Ji6jQc23DimIX4=";
  };

  cargoHash = "sha256-WHr2Ky0LlK/EVOrSK3MF9Yt/Qe/6o7Ftx7X8iECj6pM=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libgit2_1_5
    openssl
    zlib
    zstd
  ] ++ lib.optionals stdenv.isDarwin [
    curl
    darwin.apple_sdk.frameworks.Security
  ];

  buildNoDefaultFeatures = true;

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  # tests require internet access
  doCheck = false;

  meta = with lib; {
    description = "Cargo plugin to generate list of all licenses for a crate";
    homepage = "https://github.com/EmbarkStudios/cargo-deny";
    changelog = "https://github.com/EmbarkStudios/cargo-deny/blob/${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda matthiasbeyer jk ];
  };
}
