{
  lib,
  buildPythonPackage,
  fetchPypi,
  cargo,
  rustPlatform,
  rustc,
  numpy,
  black,
  isort,
  pytest,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "xinterp";
  version = "0.1.2";
  pyproject = true;

  disabled = pythonAtLeast "3.13";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZtX2NDVaoXg9p3h7g1bgMmuQlfetML/SUicIXDk4NAw=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-kUPmHvEQ8hyt/04k7GBrYEB5M//PlgE0iFhDCCgmwQo=";
  };

  build-system = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  dependencies = [
    numpy
  ];

  optional-dependencies = {
    dev = [
      black
      isort
      pytest
    ];
  };

  pythonImportsCheck = [
    "xinterp"
  ];

  meta = {
    description = "Index to value mapping both in a forward and backward way";
    homepage = "https://pypi.org/project/xinterp";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ bzizou ];
  };
}
