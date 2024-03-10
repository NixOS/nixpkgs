{ lib
, rustPlatform
, fetchFromGitHub
, clippy
, rustfmt
}:

rustPlatform.buildRustPackage rec {
  pname = "fuc";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "SUPERCILEX";
    repo = "fuc";
    rev = version;
    hash = "sha256-Y43+LB6JXxpU94BrrjSBs2ge2g3NB7O3wYeU6rbF28U=";
  };

  cargoHash = "sha256-uNG+7a9EvGLkPIu/p8tnucZ3R6/LhZ2Lfv7V0e5YIxs=";

  RUSTC_BOOTSTRAP = 1;

  cargoBuildFlags = [ "--workspace" "--bin cpz" "--bin rmz" ];

  nativeCheckInputs = [ clippy rustfmt ];

  meta = with lib; {
    description = "Modern, performance focused unix commands";
    homepage = "https://github.com/SUPERCILEX/fuc";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
