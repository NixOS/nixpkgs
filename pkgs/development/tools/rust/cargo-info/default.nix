{ lib
, rustPlatform
, fetchFromGitLab
, pkg-config
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-info";
<<<<<<< HEAD
  version = "0.7.6";
=======
  version = "0.7.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    owner = "imp";
    repo = "cargo-info";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-02Zkp7Vc1M5iZsG4iJL30S73T2HHg3lqrPJ9mW3FOuk=";
  };

  cargoHash = "sha256-zp7qklME28HNGomAcQgrEi7W6zQ1QCJc4FjxtnKySUE=";
=======
    hash = "sha256-m8YytirD9JBwssZFO6oQ9TGqjqvu1GxHN3z8WKLiKd4=";
  };

  cargoHash = "sha256-gI/DGPCVEi4Mg9nYLaPpeqpV7LBbxoLP0ditU6hPS1w=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "Cargo subcommand to show crates info from crates.io";
    homepage = "https://gitlab.com/imp/cargo-info";
    changelog = "https://gitlab.com/imp/cargo-info/-/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ mit asl20 ];
<<<<<<< HEAD
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
=======
    maintainers = with maintainers; [ figsoda ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
