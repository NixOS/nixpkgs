{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, libiconv
, darwin
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "reindeer";
  version = "unstable-2024-02-20";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = pname;
    rev = "40e0e40eac95c859a36b4a0fe8ad8f1363620fb0";
    sha256 = "sha256-bxRxFxoBt1nOXKBaYQcDYV2KB4OAnhJCaQ8iWvve8sw=";
  };

  cargoSha256 = "sha256-sQk8HXPb0tnafOdVQrtpZmn0QaoNNxBj63QW7P6tZkU=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [ openssl ] ++ lib.optionals stdenv.isDarwin [
      libiconv
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.CoreServices
    ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version" "branch" ];
  };

  meta = with lib; {
    description = "Reindeer is a tool which takes Rust Cargo dependencies and generates Buck build rules";
    homepage = "https://github.com/facebookincubator/reindeer";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ nickgerace ];
  };
}

