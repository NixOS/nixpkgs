{ lib
, stdenv
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
  version = "4.58.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fjvaag1wy70gglxjkfnn0acrya7fbhzi4adbs1bpap8x03wffn2";
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
    rich
    tkinter
  ] ++
    # pandas is not supported on i686
    lib.optional (!stdenv.isi686) pandas;

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
