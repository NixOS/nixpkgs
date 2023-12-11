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
  version = "unstable-2023-12-06";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = pname;
    rev = "5297f5fbb3140203ad796c5b22ad5ec3607bb640";
    sha256 = "sha256-o9T7mv01ncstqpOwaj3PBPGtYVXLBnYlfCtP0IbxSpw=";
  };

  cargoSha256 = "sha256-WHoOyJn+F+lMVUx2djfcbrlKAWs1fW+uhF0xiFKQes0=";

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

