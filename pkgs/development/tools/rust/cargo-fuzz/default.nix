{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  libiconv,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-fuzz";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "rust-fuzz";
    repo = "cargo-fuzz";
    rev = version;
    hash = "sha256-PC36O5+eB+yVLpz+EywBDGcMAtHl79FYwUo/l/JL8hM=";
  };

  cargoHash = "sha256-sfvepPpYtgA0TuUlu0CD50HX933AVQbUGzJBNAzFR94=";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  doCheck = false;

  meta = with lib; {
    description = "Command line helpers for fuzzing";
    mainProgram = "cargo-fuzz";
    homepage = "https://github.com/rust-fuzz/cargo-fuzz";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with maintainers; [
      ekleog
      matthiasbeyer
    ];
  };
}
