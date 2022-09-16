{ lib, rustPlatform, fetchFromGitHub, pkg-config, udev }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-espflash";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "esp-rs";
    repo = "espflash";
    rev = "v${version}";
    sha256 = "sha256-YQ621YbdEy2sS4uEYvgnQU1G9iW5SpWNObPH4BfyeF0=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    udev
  ];

  cargoSha256 = "sha256-mDSNjeaEtYpEGpiIg2F+e8x/XCssNQxUx+6Cj+8XX5Q=";

  meta = with lib; {
    description = "Serial flasher utility for Espressif SoCs and modules based on esptool.py";
    homepage = "https://github.com/esp-rs/cargo-espflash";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
