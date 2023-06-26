{ lib
, rustPlatform
, fetchFromGitHub
, clippy
, rustfmt
}:

rustPlatform.buildRustPackage rec {
  pname = "fuc";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "SUPERCILEX";
    repo = "fuc";
    rev = version;
    hash = "sha256-kbEIZljIWs/GYOQ/XCBgWsBcEwm05bf7bZmAwq+eWXo=";
  };

  patches = [ ./add_missing_feature.patch ];

  cargoHash = "sha256-AD3LdBMmyf6xM7sWUDxYZs3NltnAkEfAdxYLAbnRM4M=";

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
