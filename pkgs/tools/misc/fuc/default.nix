{ lib
, rustPlatform
, fetchFromGitHub
, clippy
, rustfmt
}:

rustPlatform.buildRustPackage rec {
  pname = "fuc";
  version = "1.1.8";

  src = fetchFromGitHub {
    owner = "SUPERCILEX";
    repo = "fuc";
    rev = version;
    hash = "sha256-jVJhV9uy49hWmBw8LVmrid/DswbdD/SOtDc1tZgBQnk=";
  };

  cargoHash = "sha256-94NdaJfIcTB6o4+iZXvuqm0OlAQrChGZEy2E7/yMxqE=";

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
