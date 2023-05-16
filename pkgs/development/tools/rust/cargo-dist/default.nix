{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, bzip2
, xz
, zstd
, stdenv
<<<<<<< HEAD
, darwin
, git
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, rustup
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-dist";
<<<<<<< HEAD
  version = "0.2.0";
=======
  version = "0.0.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "axodotdev";
    repo = "cargo-dist";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-uHkmwmEVV3+VPvp5WIc+PbwYvhYZHStiMun1yguPelw=";
  };

  cargoHash = "sha256-8bgb8CCkoqECyd9CW2OkPQmhqfiIOuelsXhOcm1d9kQ=";
=======
    hash = "sha256-uXC+iaOcEIyGMVNtAduhT68GuE29aL/3S6uEMllAWNA=";
  };

  cargoHash = "sha256-/TLi+ESOZhJ4Xg3hdUEWhM0K4asI9+L1M1+hWuDOj9Q=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    bzip2
    xz
    zstd
<<<<<<< HEAD
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  nativeCheckInputs = [
    git
  ] ++ lib.optionals stdenv.isDarwin [
    rustup
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

<<<<<<< HEAD
  # remove tests that require internet access
  postPatch = ''
    rm cargo-dist/tests/integration-tests.rs
  '';
=======
  nativeCheckInputs = lib.optionals stdenv.isDarwin [
    rustup
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A tool for building final distributable artifacts and uploading them to an archive";
    homepage = "https://github.com/axodotdev/cargo-dist";
    changelog = "https://github.com/axodotdev/cargo-dist/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 mit ];
<<<<<<< HEAD
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
=======
    maintainers = with maintainers; [ figsoda ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
