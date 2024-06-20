{
  alsa-lib,
  buildPythonPackage,
  cargo,
  fetchPypi,
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
  version = "1.6.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qGRfX7Bwr19KJnIdhwuSVBZzXxMJyEgyBuy91aLhEj4=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "skytemple_rust-1.6.4" = "sha256-t7P3F1zes7bgDu2JGqb5DgxlDCiztWtmViy4QY9CzT0=";
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
