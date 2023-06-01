{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, systemd
}:

rustPlatform.buildRustPackage rec {
  pname = "qmk_hid";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "FrameworkComputer";
    repo = "qmk_hid";
    rev = "v${version}";
    hash = "sha256-k5D+Ph4DtdTafdNhclK3t4SmHmktuOKRlMMGMmKp48E=";
  };

  cargoHash = "sha256-+frWup9sbxCAxl2oiHAn1ccpuGkfa3kjerUByd65oSI=";

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    systemd
  ];

  meta = with lib; {
    description = "Commandline tool for interactng with QMK devices over HID";
    homepage = "https://github.com/FrameworkComputer/qmk_hid";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ janik ];
  };
}
