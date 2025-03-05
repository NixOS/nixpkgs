{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,

  # build-system
  meson,
  setuptools,
  setuptools-rust,

  # buildInputs
  SDL2,
  alsa-lib,
  glib,
  libpcap,
  soundtouch,
  zlib,

  # nativeBuildInputs
  cargo,
  ninja,
  openal,
  pkg-config,
  rustc,

  # dependencies
  range-typed-integers,
}:
buildPythonPackage rec {
  pname = "skytemple-ssb-emulator";
  version = "1.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = "skytemple-ssb-emulator";
    tag = version;
    hash = "sha256-WDTSW0Vg0oL9+2J5/nIx6sd/ZWqsiDu1trpzuXNw0Kg=";
  };

  # Otherwise, fails with:
  # [-Wimplicit-function-declaration] and [-Wint-conversion] errors
  # https://github.com/SkyTemple/desmume-rs/pull/38
  postPatch = ''
    substituteInPlace "$cargoDepsCopy"/desmume-sys-*/build.rs \
      --replace-fail \
        '.arg("-Dbuildtype=release")' \
        '.arg("-Dbuildtype=release").arg("-Dc_std=gnu11").arg("-Dcpp_std=gnu++14")'
  '';

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src pname;
    hash = "sha256-Fgc0gFzDrdcV73HU39cqyw74nln4EKHokz86V8k8TAI=";
  };

  build-system = [
    meson
    setuptools
    setuptools-rust
  ];

  buildInputs = [
    SDL2
    alsa-lib
    glib
    libpcap
    soundtouch
    zlib
  ];

  nativeBuildInputs = [
    cargo
    ninja
    openal
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
  ];

  dependencies = [ range-typed-integers ];

  hardeningDisable = [ "format" ];

  doCheck = false; # there are no tests
  pythonImportsCheck = [ "skytemple_ssb_emulator" ];

  meta = {
    description = "SkyTemple Script Engine Debugger Emulator Backend";
    homepage = "https://github.com/SkyTemple/skytemple-ssb-emulator";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ marius851000 ];
  };
}
