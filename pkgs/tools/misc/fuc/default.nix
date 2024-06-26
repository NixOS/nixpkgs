{
  lib,
  rustPlatform,
  fetchFromGitHub,
  clippy,
  rustfmt,
}:

rustPlatform.buildRustPackage rec {
  pname = "fuc";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "SUPERCILEX";
    repo = "fuc";
    rev = version;
    hash = "sha256-7hXSw79hIxfPRm7nSQhdG3/M9cZ+hN4X0kRHR2PDK0U=";
  };

  cargoHash = "sha256-hnfH8ET4PVbi5qzXxa3gbOHYnlVqXA15efUefF+6zfs=";

  RUSTC_BOOTSTRAP = 1;

  cargoBuildFlags = [
    "--workspace"
    "--bin cpz"
    "--bin rmz"
  ];

  nativeCheckInputs = [
    clippy
    rustfmt
  ];

  meta = with lib; {
    description = "Modern, performance focused unix commands";
    homepage = "https://github.com/SUPERCILEX/fuc";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
