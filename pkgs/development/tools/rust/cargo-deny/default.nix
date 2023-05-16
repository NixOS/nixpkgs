{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
<<<<<<< HEAD
, zstd
, stdenv
=======
, libgit2_1_5
, openssl
, zlib
, zstd
, stdenv
, curl
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deny";
<<<<<<< HEAD
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = "cargo-deny";
    rev = version;
    hash = "sha256-IA5LaagNsAkSP7ut5iqUUI8DJMr7U+nwqVsCWR8mOnY=";
  };

  cargoHash = "sha256-xiVZNBIdnRorMZDabpfE6Pans3Nh56VA29fYRu7N5cE=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    zstd
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

=======
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

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
