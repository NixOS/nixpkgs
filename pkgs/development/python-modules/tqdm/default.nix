{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
, pytestCheckHook
, pytest-asyncio
, pytest-timeout
, numpy
, pandas
, rich
, tkinter
}:

buildPythonPackage rec {
  pname = "tqdm";
  version = "4.59.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d666ae29164da3e517fcf125e41d4fe96e5bb375cd87ff9763f6b38b5592fe33";
  };

  nativeBuildInputs = [
    setuptools_scm
  ];

  checkInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-timeout
    # tests of optional features
    numpy
    pandas
    rich
    tkinter
  ];

  # Remove performance testing.
  # Too sensitive for on Hydra.
  PYTEST_ADDOPTS = "-k \"not perf\"";

  LC_ALL="en_US.UTF-8";

  meta = {
    description = "A Fast, Extensible Progress Meter";
    homepage = "https://github.com/tqdm/tqdm";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fridh ];
  };
}
