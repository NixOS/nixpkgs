{ lib
, buildPythonPackage
, fetchPypi
, fetchFromGitHub
, setuptools-rust
, wheel
, rustPlatform
, rustc
, cargo
, unzip
, milksnake
, cffi
}:

buildPythonPackage rec {
  pname = "symbolic";
  version = "10.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "symbolic";
    rev = "${version}";
    hash = "sha256-3u4MTzaMwryGpFowrAM/MJOmnU8M+Q1/0UtALJib+9A=";
    forceFetchGit = true;
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-5BoiGzpsQ5KrzZ5Fz/ZEKkVZpLe2YTpx1uSnlJWe1wQ=";
    postPatch = ''
      ln -s ${./Cargo.lock} Cargo.lock
    '';
  };

  build-system = [
    setuptools-rust
    wheel
    rustPlatform.cargoSetupHook
    rustc
    cargo
    milksnake
  ];

  dependencies = [
    cffi
  ];

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  preBuild = ''
    cd py
  '';

  pythonImportsCheck = [ "symbolic" ];

  meta = {
    description = "A python library for dealing with symbol files and more";
    homepage = "https://pypi.org/project/symbolic";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ soyouzpanda ];
  };
}
