{ lib
, rustPlatform
, fetchFromGitHub
, substituteAll
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-benchcmp";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = "cargo-benchcmp";
    rev = version;
    hash = "sha256-pg3/VUC1DQ7GbSQDfVZ0WNisXvzXy0O0pr2ik2ar2h0=";
  };

  cargoHash = "sha256-vxy9Ym3Twx034I1E5fWNnbP1ttfLolMbO1IgRiPfhRw=";

  patches = [
    # patch the binary path so tests can find the binary when `--target` is present
    (substituteAll {
      src = ./fix-test-binary-path.patch;
      shortTarget = stdenv.hostPlatform.rust.rustcTarget;
    })
  ];

  checkFlags = [
    # thread 'different_input_colored' panicked at 'assertion failed: `(left == right)`
    "--skip=different_input_colored"
  ];

  meta = with lib; {
    description = "A small utility to compare Rust micro-benchmarks";
    mainProgram = "cargo-benchcmp";
    homepage = "https://github.com/BurntSushi/cargo-benchcmp";
    license = with licenses; [ mit unlicense ];
    maintainers = with maintainers; [ figsoda ];
  };
}
