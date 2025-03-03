{
  alsa-lib,
  buildPythonPackage,
  cargo,
  fetchFromGitHub,
  glib,
  lib,
  libpcap,
  meson,
  ninja,
  openal,
  pkg-config,
  range-typed-integers,
  rustc,
  rustPlatform,
  SDL2,
  setuptools,
  setuptools-rust,
  soundtouch,
  zlib,
}:
buildPythonPackage rec {
  pname = "skytemple-ssb-emulator";
  version = "1.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = pname;
    rev = version;
    hash = "sha256-WDTSW0Vg0oL9+2J5/nIx6sd/ZWqsiDu1trpzuXNw0Kg=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-Fgc0gFzDrdcV73HU39cqyw74nln4EKHokz86V8k8TAI=";
  };

  buildInputs = [
    alsa-lib
    glib
    libpcap
    SDL2
    soundtouch
    zlib
  ];

  nativeBuildInputs = [
    cargo
    meson
    ninja
    openal
    pkg-config
    rustc
    rustPlatform.cargoSetupHook
    setuptools
    setuptools-rust
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration -Wno-error=int-conversion";

  propagatedBuildInputs = [ range-typed-integers ];

  hardeningDisable = [ "format" ];

  doCheck = false; # there are no tests
  pythonImportsCheck = [ "skytemple_ssb_emulator" ];

  meta = with lib; {
    description = "SkyTemple Script Engine Debugger Emulator Backend";
    homepage = "https://github.com/SkyTemple/skytemple-ssb-emulator";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ marius851000 ];
  };
}
