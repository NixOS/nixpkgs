{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  systemd,
}:

rustPlatform.buildRustPackage rec {
  pname = "qmk_hid";
  version = "0.1.11";

  src = fetchFromGitHub {
    owner = "FrameworkComputer";
    repo = "qmk_hid";
    rev = "v${version}";
    hash = "sha256-k5cZcrjen7nNJM9mKQEwNTVfBPawXwbwNlCyTARdH/g=";
  };

  cargoHash = "sha256-GrerrNDoSFtOEAf0vB9MlkBl+yLnzd/szrpFsAmkB6s=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    systemd
  ];

  checkFlags = [
    # test doesn't compile
    "--skip=src/lib.rs"
  ];

  meta = with lib; {
    description = "Commandline tool for interactng with QMK devices over HID";
    homepage = "https://github.com/FrameworkComputer/qmk_hid";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ janik ];
    mainProgram = "qmk_hid";
  };
}
