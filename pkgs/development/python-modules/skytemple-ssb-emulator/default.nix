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
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = pname;
    rev = version;
    hash = "sha256-9xD9Q/oYsi9tuxTOJ6ItLbWkqAjG78uzXYZXOiITDEA=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "skytemple_rust-1.8.1" = "sha256-KtMqgUOlyF02msQRouE4NpvCHqahY+aRiRV9P32ASqg=";
    };
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
