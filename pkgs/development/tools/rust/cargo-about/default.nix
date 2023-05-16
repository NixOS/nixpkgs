{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, zstd
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-about";
<<<<<<< HEAD
  version = "0.5.7";
=======
  version = "0.5.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = "cargo-about";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-AROT/Q/C0lbkeoMYmY2Tzt0+yRVA8ESRo5mPM1h0HJs=";
  };

  cargoSha256 = "sha256-9HkaCUGo6jpzQn851ACM7kcBCkyMJJ/bb/qtV4Hp0lI=";
=======
    sha256 = "sha256-nlumcRcL5HwRJTNqLJ9+UkSg88HuE96Rg8Tgc+ZcK2M=";
  };

  cargoSha256 = "sha256-Fa1DGXzHDR3EAZyFg0g2aKFynQlC/LL+Tg5LKpOUzmM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ zstd ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  meta = with lib; {
    description = "Cargo plugin to generate list of all licenses for a crate";
    homepage = "https://github.com/EmbarkStudios/cargo-about";
    changelog = "https://github.com/EmbarkStudios/cargo-about/blob/${version}/CHANGELOG.md";
    license = with licenses; [ mit /* or */ asl20 ];
<<<<<<< HEAD
    maintainers = with maintainers; [ evanjs figsoda matthiasbeyer ];
    mainProgram = "cargo-about";
=======
    maintainers = with maintainers; [ evanjs figsoda ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
