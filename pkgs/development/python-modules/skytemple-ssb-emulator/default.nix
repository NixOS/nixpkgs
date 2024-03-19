{ alsa-lib
, buildPythonPackage
, cargo
, fetchPypi
, glib
, lib
, libpcap
, meson
, ninja
, openal
, pkg-config
, range-typed-integers
, rustc
, rustPlatform
, SDL2
, setuptools
, setuptools-rust
, soundtouch
, zlib
}:
buildPythonPackage rec {
  pname = "skytemple-ssb-emulator";
  version = "1.6.1.post1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FEQnQPIathtrP03Dncz560K0lhKW4+HI/Oyo7qsEpFw=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "skytemple_rust-1.6.0" = "sha256-4glBo1VKCSwSSeQU6Ojhc0Cbaikxy101V1fU4rgcczg=";
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

  propagatedBuildInputs = [
    range-typed-integers
  ];

  hardeningDisable = [
    "format"
  ];

  doCheck = false; # there are no tests
  pythonImportsCheck = [
    "skytemple_ssb_emulator"
  ];

  meta = with lib; {
    description = "SkyTemple Script Engine Debugger Emulator Backend";
    homepage = "https://github.com/SkyTemple/skytemple-ssb-emulator";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ marius851000 xfix ];
  };
}
