{ lib
, rustPlatform
, fetchFromGitHub
, libevdev
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "evremap";
  version = "unstable-2024-03-11";

  src = fetchFromGitHub {
    owner = "wez";
    repo = "evremap";
    rev = "d0e8eb231fdeaf9c6457b36c1f04164150a82ad0";
    hash = "sha256-FRUJ2n6+/7xLHVFTC+iSaigwhy386jXccukoMiRD+bw=";
  };
  cargoLock.lockFile = "${src}/Cargo.lock";

  nativeBuildInputs = [
    libevdev
    pkg-config
  ];

  cargoHash = lib.fakeHash;
  cargoBuildFlags = [ "--release" "--all-features" ];

  RUSTUP_TOOLCHAIN = "stable";
  PKG_CONFIG_PATH = "${libevdev}/lib/pkgconfig";

  meta = with lib; {
    description = "A keyboard input remapper for Linux/Wayland systems, written by @wez";
    homepage = https://github.com/wez/evremap;
    license = licenses.mit;
    platforms = platforms.all;
  };
}
