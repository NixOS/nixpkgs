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
  version = "1.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = "skytemple-ssb-emulator";
    tag = version;
    hash = "sha256-zmLEvE96gkElTggcRG9fZDrJPLOXeNuSk49zXQAB69Y=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src pname;
    hash = "sha256-MSPqQmC70pq+sEM8zJrrFiz32dorOJxr2G/y2H4EUQI=";
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
